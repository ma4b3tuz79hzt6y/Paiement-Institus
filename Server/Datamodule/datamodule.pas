unit DataModule;

interface

uses
  SysUtils, ZConnection, ZDataset,DB, Classes,fpjson, IniFiles,uoutils;

type
  { TDM }
  TDM = class(TDataModule)
    FConnection: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LoadDatabaseConfig;
    procedure ExecuteSQLQuery(SQLText: string; Params: array of string; var Message, Success: string);overload;
    function ExecuteSQLQuery2(SQLText: string;  var Message, Success: string): TJSONArray;
  public
    function GetConnection: TZConnection;
    procedure AjouterEntity(EntityName: string; Params: array of string; var Message, Success: string);
    procedure MiseAjourEntity(EntityName: string;  Params: array of string; var Message, Success: string);
    procedure SupprimerEntity(EntityName: string; ID: string; var Message, Success: string);
    function AllEntity(EntityName: string; var Message, Success: string): TJSONArray;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ Chargement des paramètres de connexion depuis un fichier .ini }
procedure TDM.LoadDatabaseConfig;
var
  Ini: TIniFile;
  DBHost, DBName, DBUser, DBPassword: string;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    DBHost := Ini.ReadString('Database', 'Host', 'localhost');
    DBName := Ini.ReadString('Database', 'Name', 'paiement_institus');
    DBUser := Ini.ReadString('Database', 'User', 'root');
    DBPassword := Ini.ReadString('Database', 'Password', '12345678');

    FConnection.HostName := DBHost;
    FConnection.Database := DBName;
    FConnection.User := DBUser;
    FConnection.Password := DBPassword;
    FConnection.Protocol := 'mysql';
  finally
    Ini.Free;
  end;
end;

function TDM.GetConnection: TZConnection;
begin
  if not FConnection.Connected then
    FConnection.Connected := True;
  Result := FConnection;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  LoadDatabaseConfig;
  GetConnection;
end;

{ Exécution générique d'une requête SQL avec paramètres et récupération des résultats }
procedure TDM.ExecuteSQLQuery(SQLText: string; Params: array of string; var Message, Success: string);
var
  ZQuery: TZQuery;
  I: Integer;
begin
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := GetConnection;
    FConnection.StartTransaction;
    try
      ZQuery.SQL.Text := SQLText;
      for I := 0 to High(Params) div 2 do
        ZQuery.Params.ParamByName(Params[I*2]).AsString := Params[I*2+1];

      ZQuery.ExecSQL;
      ZQuery.SQL.Text := 'SELECT @message as message, @success as success';
      ZQuery.Open;
      Message := ZQuery.FieldByName('message').AsString;
      Success := ZQuery.FieldByName('success').AsString;
      FConnection.Commit;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        Message := 'Erreur: ' + E.Message;
        Success := 'FALSE';
      end;
    end;
  finally
    ZQuery.Free;
  end;
end;

{ Ajout d'une entité générique (Filière, Stagiaire, etc.) }
procedure TDM.AjouterEntity(EntityName: string; Params: array of string; var Message, Success: string);
var
  SQLText: string;
begin
  SQLText := Format('CALL %s(%s, @message, @success)', [EntityName,JoinParams(Params)]);
  ExecuteSQLQuery(SQLText, Params, Message, Success);
end;

{ Mise à jour d'une entité générique }
procedure TDM.MiseAjourEntity(EntityName: string;  Params: array of string; var Message, Success: string);
var
  SQLText: string;
begin
  SQLText := Format('CALL %s(%s, @message, @success)', [EntityName, JoinParams(Params)]);
  ExecuteSQLQuery(SQLText, Params, Message, Success);
end;

{ Suppression d'une entité générique }
procedure TDM.SupprimerEntity(EntityName: string; ID: string; var Message, Success: string);
var
  SQLText: string;
begin
  SQLText := Format('CALL %s(:id, @message, @success)', [EntityName]);
  ExecuteSQLQuery(SQLText, ['id', ID], Message, Success);
end;

function TDM.AllEntity(EntityName: string; var Message, Success: string): TJSONArray;
var
  SQLText: string;
begin
  SQLText := Format('CALL %s( @message, @success)', [EntityName]);
 Result:= ExecuteSQLQuery2(SQLText, Message, Success);

end;

function TDM.ExecuteSQLQuery2(SQLText: string; var Message, Success: string): TJSONArray;
var
  ZQuery: TZQuery;
  //JSONArray: TJSONArray;
begin
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := GetConnection;
    FConnection.StartTransaction;
    //JSONArray := TJSONArray.Create;
    try
      ZQuery.SQL.Text := SQLText;
      ZQuery.open;
      Result := DataSetToJSONArray(ZQuery);
      ZQuery.SQL.Text := 'SELECT @message as message, @success as success';
      ZQuery.Open;
      Message := ZQuery.FieldByName('message').AsString;
        //Message := 'Stagiaires recuperées';
      Success := ZQuery.FieldByName('success').AsString;
     // Success := 'TRUE';

      FConnection.Commit;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        Message := 'Erreur: ' + E.Message;
        Success := 'FALSE';
      end;
    end;
  finally
   ZQuery.Free;
  end;

end;

end.

