unit Uoutils;

{$mode Delphi}

interface
   uses

  Classes, SysUtils,fpjson, db;
 function JoinParams(const Params: array of string): string;
 function DataSetToJSONArray(DataSet: TDataSet): TJSONArray;
implementation


function JoinParams(const Params: array of string): string;
var
  I: Integer;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    for I := 0 to High(Params) div 2 do
    begin
      if SB.Length > 0 then
        SB.Append(', ');
      SB.Append(':').Append(Params[I * 2]);
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;



function DataSetToJSONArray(DataSet: TDataSet): TJSONArray;
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  I: Integer;
begin
  JSONArray := TJSONArray.Create;

  // Parcourir les enregistrements
  DataSet.First;
  while not DataSet.EOF do
  begin
    JSONObject := TJSONObject.Create;

    // Parcourir les champs de l'enregistrement
    for I := 0 to DataSet.FieldCount - 1 do
    begin
      JSONObject.Add(DataSet.Fields[I].FieldName, DataSet.Fields[I].AsString);
    end;

    JSONArray.Add(JSONObject);
    DataSet.Next;
  end;

  Result := JSONArray;
end;



end.

