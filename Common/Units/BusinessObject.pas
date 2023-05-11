unit BusinessObject;

interface

uses
  System.SysUtils, System.Classes, System.JSON, CommonFunctions;

type
  TBusinessObject = class
  public
    function ToJsonString: String;
    procedure FromJsonString(AValue: String);
    function ToJsonObject: TJsonObject; virtual; abstract;
    procedure FromJsonObject(AObject: TJsonObject); virtual; abstract;
  end;

implementation

function TBusinessObject.ToJsonString: String;
var
  LObj: TJsonObject;
begin
  LObj := ToJsonObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TBusinessObject.FromJsonString(AValue: String);
var
  LObj: TJsonObject;
begin
  LObj := ToJsonObject.ParseJSONValue(AValue) as TJsonObject;
  try
    FromJsonObject(LObj);
  finally
    LObj.Free;
  end;
end;

end.
