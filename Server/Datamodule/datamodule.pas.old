unit DataModule;

interface

uses
  SysUtils, ZConnection, ZDataset, Classes;

type

  { TDM }

  TDM = class(TDataModule)
    FConnection: TZConnection;
    procedure DataModuleCreate(Sender: TObject);


  private

  public
    procedure AjouterFiliere(Nom: string; fin_incription: string;
      var Message: string; var Success: string);
    procedure MiseAjourFiliere(ID, Nom,fin_incription: string;
      var Message: string; var Success: string);
    procedure SuprimerFilier(ID: string; var Message: string;
      var Success: string);
    function GetConnection: TZConnection;
    procedure AjouterStagiaire(Nom, Prenom, Email, Telephone: string; var Message: string; var Success: string);
    procedure MiseAjourStagiaire(ID,Nom, Prenom, Email, Telephone: string; var Message: string; var Success: string);
    procedure SuprimerStagiaire(ID: string; var Message: string; var Success: string);
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

function TDM.GetConnection: TZConnection;
begin
  if not Assigned(FConnection) then
  begin
    //FConnection := TZConnection.Create(nil);
    FConnection.HostName := 'localhost'; // Modifier selon votre configuration
    FConnection.Database := 'paiement_institus';
    FConnection.User := 'root'; // Modifier selon votre configuration
    FConnection.Password := '12345678';
    FConnection.Protocol := 'mysql';
    FConnection.Connected := True;
  end;
  Result := FConnection;
end;

procedure TDM.AjouterStagiaire(Nom, Prenom, Email, Telephone: string; var Message: string; var Success: string);
var

  ZQuery: TZQuery;
begin
  // Initialisation de la connexion
  //ZConnection := TZConnection.Create(nil);
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := FConnection;

    // Exécution de la procédure stockée
    with ZQuery do
    begin
      SQL.Text := 'CALL ajouter_stagiaire(:nom, :prenom, :email, :telephone, @message, @success)';
      Params.ParamByName('nom').AsString := Nom;
      Params.ParamByName('prenom').AsString := Prenom;
      Params.ParamByName('email').AsString := Email;
      Params.ParamByName('telephone').AsString := Telephone;
      ExecSQL;

      // Récupération des valeurs de sortie
      SQL.Text := 'SELECT @message as message, @success as success ';
      Open;
      Message := FieldByName('message').AsString;
      Success := FieldByName('success').AsString;
      // Convertir @success en Boolean
    {if ZQuery.Fields[1].AsString = '1' then
      Success := True
    else
      Success := False;}
    end;
  except
    on E: Exception do
    begin
      Message := 'Erreur: ' + E.Message;
      Success := 'FALSE';
    end;
  end;
  FreeAndNil(ZQuery);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  //
 GetConnection;
end;

procedure TDM.MiseAjourStagiaire(ID, Nom, Prenom, Email, Telephone: string;
  var Message: string; var Success: string);
var

  ZQuery: TZQuery;
begin
  // Initialisation de la connexion
  //ZConnection := TZConnection.Create(nil);

  ZQuery := TZQuery.Create(nil);
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := FConnection;

    // Exécution de la procédure stockée
    with ZQuery do
    begin
      SQL.Text := 'CALL mettre_a_jour_stagiaire(:id,:nom, :prenom, :email, :telephone, @message, @success)';
      Params.ParamByName('id').AsString := ID;
      Params.ParamByName('nom').AsString := Nom;
      Params.ParamByName('prenom').AsString := Prenom;
      Params.ParamByName('email').AsString := Email;
      Params.ParamByName('telephone').AsString := Telephone;
      ExecSQL;
       Sleep(20) ;
      // Récupération des valeurs de sortie

      SQL.Text := 'SELECT @message as message, @success as success';
      Open;
      Message := FieldByName('message').AsString;
      Success := FieldByName('Success').AsString;
    end;
  except
    on E: Exception do
    begin
      Message := 'Erreur: ' + E.Message;
      Success := 'FALSE';
    end;
  end;
  FreeAndNil(ZQuery);

end;

procedure TDM.SuprimerStagiaire(ID : string;var Message: string; var Success: string);
var
  ZQuery: TZQuery;
begin
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := FConnection;

    // Exécution de la procédure stockée
    with ZQuery do
    begin
      SQL.Text := 'CALL supprimer_stagiaire(:id, @message, @success)';
      Params.ParamByName('id').AsString := ID;
      ExecSQL;

      // Récupération des valeurs de sortie
      SQL.Text := 'SELECT @message as message, @success as success ';
      Open;
      Message := FieldByName('message').AsString;
      Success := FieldByName('success').AsString;
    end;
  except
    on E: Exception do
    begin
      Message := 'Erreur: ' + E.Message;
      Success := 'FALSE';
    end;
  end;
  FreeAndNil(ZQuery);

end;

procedure TDM.AjouterFiliere(Nom:string; fin_incription: string; var Message: string; var Success: string);
var

  ZQuery: TZQuery;
begin
  // Initialisation de la connexion
  //ZConnection := TZConnection.Create(nil);
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := FConnection;

    // Exécution de la procédure stockée
    with ZQuery do
    begin
      SQL.Text := 'CALL AjouterFiliere(:nom, :fin_incription, @message, @success)';
      Params.ParamByName('nom').AsString := Nom;
      Params.ParamByName('fin_incription').AsString := fin_incription;

      ExecSQL;

      // Récupération des valeurs de sortie
      SQL.Text := 'SELECT @message as message, @success as success ';
      Open;
      Message := FieldByName('message').AsString;
      Success := FieldByName('success').AsString;
      // Convertir @success en Boolean
    {if ZQuery.Fields[1].AsString = '1' then
      Success := True
    else
      Success := False;}
    end;
  except
    on E: Exception do
    begin
      Message := 'Erreur: ' + E.Message;
      Success := 'FALSE';
    end;
  end;
  FreeAndNil(ZQuery);
end;

procedure TDM.MiseAjourFiliere(ID, Nom ,fin_incription: string; var Message: string; var Success: string);
var
  ZQuery: TZQuery;
begin
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := FConnection;

    // Exécution de la procédure stockée
    with ZQuery do
    begin
      SQL.Text := 'CALL ModifierFiliere(:id,:nom,:fin_incription, @message, @success)';
      Params.ParamByName('id').AsString := ID;
      Params.ParamByName('nom').AsString := Nom;
      Params.ParamByName('fin_incription').Asstring := fin_incription;//strtodate('2025-10-10'); //StrToDate(fin_incription);
      ExecSQL;
       Sleep(20) ;
      // Récupération des valeurs de sortie

      SQL.Text := 'SELECT @message as message, @success as success';
      Open;
      Message := FieldByName('message').AsString;
      Success := FieldByName('Success').AsString;
    end;
  except
    on E: Exception do
    begin
      Message := 'Erreur: ' + E.Message+ '      : '  + fin_incription;
      Success := 'FALSE';
    end;
  end;
  FreeAndNil(ZQuery);

end;

procedure TDM.SuprimerFilier(ID : string;var Message: string; var Success: string);
var
  ZQuery: TZQuery;
begin
  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := FConnection;

    // Exécution de la procédure stockée
    with ZQuery do
    begin
      SQL.Text := 'CALL SupprimerFiliere(:id, @message, @success)';
      Params.ParamByName('id').AsString := ID;
      ExecSQL;

      // Récupération des valeurs de sortie
      SQL.Text := 'SELECT @message as message, @success as success ';
      Open;
      Message := FieldByName('message').AsString;
      Success := FieldByName('success').AsString;
    end;
  except
    on E: Exception do
    begin
      Message := 'Erreur: ' + E.Message;
      Success := 'FALSE';
    end;
  end;
  FreeAndNil(ZQuery);

end;

end.


