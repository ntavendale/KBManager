unit DBVersion;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, Settings, CommonFunctions,
  FireDAC.Stan.Option, System.Generics.Collections;

type
  TDBVersion = class
    protected
      FMajor: Integer;
      FMinor: Integer;
      FPatch: Integer;
      FRevision: Integer;
      FDateUpdated: TDateTime;
    public
      constructor Create; overload; virtual;
      constructor Create(ADBVersion: TDBVersion); overload; virtual;
      procedure Save;
      property Major: Integer read FMajor write FMajor;
      property Minor: Integer read FMinor write FMinor;
      property Patch: Integer read FPatch write FPatch;
      property Revision: Integer read FRevision write FRevision;
      property DateUpdated: TDateTime read FDateUpdated write FDateUpdated;
  end;

  TDBVersionList = class
    protected
      FList: TObjectList<TDBVersion>;
      function GetCount: Integer;
      function GetDBVersion(AIndex: Integer): TDBVersion;
      class function GetInitialSQL: TStringList;
      class function CreateDBVersion(ADataSet: TDataSet): TDBVersion;
    public
      constructor Create; overload; virtual;
      constructor Create(ADBVersionList: TDBVersionList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ADBVersion: TDBVersion);
      property Count: Integer read GetCount;
      property DBVersion[AIndex: Integer]: TDBVersion read GetDBVersion; default; 
  end;

implementation

constructor TDBVersion.Create;
begin
  FMajor := 0;
  FMinor := 0;
  FPatch := 0;
  FRevision := 0;
  FDateUpdated := -1.00;
end;

constructor TDBVersion.Create(ADBVersion: TDBVersion);
begin
  FMajor := ADBVersion.Major;
  FMinor := ADBVersion.Minor;
  FPatch := ADBVersion.Patch;
  FRevision := ADBVersion.Revision;
  FDateUpdated := ADBVersion.DateUpdated;
end;

procedure TDBVersion.Save;
var
  i: Integer;
  LConnection: TFDConnection;
  LSettings: TSettings;
  LUpsert: TFDStoredProc;
begin
  LSettings := TSettings.Create;
  try
    LSettings.Load;
    LConnection := TDataServices.GetConnection('MedLynxPatientData', LSettings.PatientDataUserName, LSettings.PatientDataPassword, LSettings.PatientDataDatabase, LSettings.PatientDataHost);
  finally
    LSettings.Free;
  end;

  try
    LUpsert := TFDStoredProc.Create(nil);
    try
      LUpsert.FetchOptions.Items := LUpsert.FetchOptions.Items - [fiMeta];
      LUpsert.StoredProcName := 'PatientData_UpdateDBVersion';
      LUpsert.Params.Clear;
      LUpsert.Params.Add('@RETURN_VALUE', ftInteger, -1, ptResult);
      LUpsert.Params.Add('@Major', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Minor', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Patch', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@Revision', ftInteger, -1, ptInput);
      LUpsert.Params.Add('@DateUpdated', ftDateTime, -1, ptInput);
      LUpsert.Params.Add('@NextDBVersionPK', ftInteger, -1, ptOutput);

      LUpsert.Connection := LConnection;
      LConnection.Connected := TRUE;

      LUpsert.Params.ParamByName('@Major').AsInteger := FMajor;
      LUpsert.Params.ParamByName('@Minor').AsInteger := FMinor;
      LUpsert.Params.ParamByName('@Patch').AsInteger := FPatch;
      LUpsert.Params.ParamByName('@Revision').AsInteger := FRevision;
      LUpsert.Params.ParamByName('@DateUpdated').AsDateTime := FDateUpdated;

      LUpsert.ExecProc;

      FPreAdmissionCheckListPK := LUpsert.Params.ParamByName('@NextDBVersionPK').AsInteger;
    finally
      LConnection.Connected := FALSE;
      LUpsert.Free;
    end;
  finally
    LConnection.Free;
  end;
end;

function TDBVersionList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDBVersionList.GetDBVersion(AIndex: Integer): TDBVersion;
begin
  Result := FList[AIndex];
end;

class function TDBVersionList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select DBVersion.Major, ');
  Result.Add('DBVersion.Minor, ');
  Result.Add('DBVersion.Patch, ');
  Result.Add('DBVersion.Revision, ');
  Result.Add('DBVersion.DateUpdated, ');
  Result.Add('From DBVersion ');
end;

class function TDBVersionList.CreateDBVersion(ADataSet: TDataSet): TDBVersion;
begin
  Result := TDBVersion.Create;
  Result.Major := ADataSet.Fields[0].AsInteger;
  Result.Minor := ADataSet.Fields[1].AsInteger;
  Result.Patch := ADataSet.Fields[2].AsInteger;
  Result.Revision := ADataSet.Fields[3].AsInteger;
  Result.DateUpdated := ADataSet.Fields[4].AsDateTime;
end;

constructor TDBVersionList.Create;
begin
  inherited Create;
  FList := TObjectList<TDBVersion>.Create(TRUE);
end;

constructor TDBVersionList.Create(ADBVersionList: TDBVersionList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TDBVersion>.Create(TRUE);
  for i := 0 to (ADBVersionList.Count - 1) do 
    FList.Add(TDBVersion.Create(ADBVersionList[i]));
end;

destructor TDBVersionList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TDBVersionList.Clear;
begin
  FList.Clear;
end;

procedure TDBVersionList.Add(ADBVersion: TDBVersion);
begin
  FList.Add(ADBVersion);
end;

end.
