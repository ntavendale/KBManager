unit KBVersion;

interface

uses
  System.SysUtils, System.Classes;

type
  TKBVersion = record
     Major: Integer;
     Minor: Integer;
     Release: Integer;
     Build: Integer;
     class operator Implicit(a: String): TKBVersion;     // Implicit conversion of an Integer to type TMyClass
     class operator Implicit(a: TKBVersion): String;     // Implicit conversion of TMyClass to Integer
     class operator Equal(a, b: TKBVersion) : Boolean;
     class operator GreaterThan(a, b: TKBVersion) : Boolean;
     class operator GreaterThanOrEqual(a, b: TKBVersion) : Boolean;
     class operator LessThan(a, b: TKBVersion) : Boolean;
     class operator LessThanOrEqual(a, b: TKBVersion) : Boolean;
   end;

implementation

class operator TKBVersion.Implicit(a: String): TKBVersion;
var
  LComponents: TArray<String>;
  Len: Integer;
begin
  if String.IsNullOrWhiteSpace(a) then
    raise EConvertError.Create('String is not a valid Version');

  LComponents := a.Split(['.']);
  Len := Length(LComponents);
  if (0 = Length(LComponents)) then
    raise EConvertError.Create('String is not a valid Version');

  Result.Major := 0;
  Result.Minor := 0;
  Result.Release := 0;
  Result.Build := 0;

  if Len > 0 then
  begin
    try
      Result.Major := StrToInt(LComponents[0].Trim);
    except
      raise EConvertError.Create('String is not a valid Version');
    end;
  end;

  if Len > 1 then
  begin
    try
      Result.Minor := StrToInt(LComponents[1].Trim);
    except
      raise EConvertError.Create('String is not a valid Version');
    end;
  end;

  if Len > 2 then
  begin
    try
      Result.Release := StrToInt(LComponents[2].Trim);
    except
      raise EConvertError.Create('String is not a valid Version');
    end;
  end;

  if Len > 3 then
  begin
    try
      Result.Build := StrToInt(LComponents[3].Trim);
    except
      raise EConvertError.Create('String is not a valid Version');
    end;
  end;
end;

class operator TKBVersion.Implicit(a: TKBVersion): String;     // Implicit conversion of TMyClass to Integer
begin
  Result := String.Format('%d.%d.%d.%d', [a.Major, a.Minor, a.Release, a.Build]);
end;

class operator TKBVersion.Equal(a, b: TKBVersion) : Boolean;
begin
  Result := (a.Major = b.Major) and
            (a.Minor = b.Minor) and
            (a.Build = b.Build) and
            (a.Release = b.Release);
end;

class operator TKBVersion.GreaterThan(a, b: TKBVersion) : Boolean;
begin
  Result := (a.Major > b.Major) or
            ((a.Major = b.Major) and (a.Minor > b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build > b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release > b.Release));
end;

class operator TKBVersion.GreaterThanOrEqual(a, b: TKBVersion) : Boolean;
begin
  Result := (a.Major = b.Major) and
            (a.Minor = b.Minor) and
            (a.Build = b.Build) and
            (a.Release = b.Release);
  if Result then
    EXIT;

  Result := (a.Major > b.Major) or
            ((a.Major = b.Major) and (a.Minor > b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build > b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release > b.Release));
end;

class operator TKBVersion.LessThan(a, b: TKBVersion) : Boolean;
begin
  Result := (a.Major < b.Major) or
            ((a.Major = b.Major) and (a.Minor < b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build < b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release < b.Release));
end;

class operator TKBVersion.LessThanOrEqual(a, b: TKBVersion) : Boolean;
begin
  Result := (a.Major = b.Major) and
            (a.Minor = b.Minor) and
            (a.Build = b.Build) and
            (a.Release = b.Release);
  if Result then
    EXIT;

  Result := (a.Major < b.Major) or
            ((a.Major = b.Major) and (a.Minor < b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build < b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release < b.Release));
end;

end.
