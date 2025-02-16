unit Uoutils;

{$mode Delphi}

interface

uses
  Classes, SysUtils;
 function JoinParams(Params: array of string): string;
implementation
  function JoinParams(Params: array of string): string;
var
  I: Integer;
  ResultParams: string;
begin
  ResultParams := '';
  for I := 0 to High(Params) div 2 do
    ResultParams := ResultParams + ':' + Params[I*2] + ', ';

  SetLength(ResultParams, Length(ResultParams) - 2); // Retirer la dernière virgule
  Result := ResultParams;
end;

end.

