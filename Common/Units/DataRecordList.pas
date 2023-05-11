unit DataRecordList;

interface

uses
  System.SysUtils, System.Classes, System.JSON, CommonFunctions;

type
  TDataRecordList = class
    protected
      {Protected declarations }
      function GetCount: Integer; virtual; abstract;
      function GetFieldCount: Integer; virtual; abstract;
      function GetFieldCaption(AIndex: Integer): String; virtual; abstract;
      function GetFieldData(ARecord, AIndex: Integer): Variant; virtual; abstract;
    public
      {Protected declarations }
      function ToJsonString: String;
      procedure FromJsonString(AValue: String);
      function ToJsonArray: TJsonArray; virtual; abstract;
      procedure FromJsonArray(AArray: TJsonArray); virtual; abstract;
      property Count: Integer read GetCount;
      property FieldCount: Integer read GetFieldCount;
      property FieldCaptions[AIndex: Integer]: String read GetFieldCaption;
      property FieldData[ARecord, AIndex: Integer]: Variant read GetFieldData;
  end;

implementation

function TDataRecordList.ToJsonString: String;
var
  LArray: TJsonArray;
begin
  LArray := ToJsonArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TDataRecordList.FromJsonString(AValue: String);
var
  LArr: TJsonArray;
begin
  LArr := TJsonObject.ParseJSONValue(AValue) as TJsonArray;
  try
    FromJsonArray(LArr);
  finally
    LArr.Free;
  end;
end;

end.
