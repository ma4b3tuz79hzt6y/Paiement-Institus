unit StagiaireController;

interface

uses

  Horse, DataModule, SysUtils, fpjson, jsonparser;

procedure AjouterStagiaireController(Request: THorseRequest; Response: THorseResponse);
procedure MiseAjourStagiaireController(Request: THorseRequest; Response: THorseResponse);
procedure SuprimerStagiaireController(Request: THorseRequest; Response: THorseResponse) ;
procedure AllStagiaireController(Request: THorseRequest; Response: THorseResponse) ;

implementation

procedure AjouterStagiaireController(Request: THorseRequest; Response: THorseResponse);
var
  Nom, Prenom, Email, Telephone, Message: string;
  Success: string;
  JSONData: TJSONData;
  JSONStr: string;
  JsonResponse: TJSONObject; // Utilisation de fpjson.TJSONObject
begin
  try
    // Récupérer le corps de la requête sous forme de chaîne de caractères
    JSONStr := Request.Body;

    // Analyser la chaîne JSON directement avec fpjson
    JSONData := GetJSON(JSONStr); // Utilisation de GetJSON pour analyser le JSON

    // Extraction des champs JSON
    Nom := JSONData.FindPath('nom').AsString;
    Prenom := JSONData.FindPath('prenom').AsString;
    Email := JSONData.FindPath('email').AsString;
    Telephone := JSONData.FindPath('telephone').AsString;

    // Appel à la méthode du DataModule
    //DM.AjouterStagiaire(Nom, Prenom, Email, Telephone, Message, Success);
DM.AjouterEntity('ajouter_stagiaire', ['nom', Nom, 'Prenom',Prenom,'Email',Email,'Telephone', Telephone], Message, Success);



     // Créer la réponse JSON avec fpjson
    JsonResponse := TJSONObject.Create;
    JsonResponse.Add('success', Success); // Utilisation de TJSONBoolean
    JsonResponse.Add('message', Message); // Ajouter le message

    // Envoyer la réponse JSON sous forme de chaîne
    Response.Send(JsonResponse.AsJSON);

  except
    on E: Exception do
    begin
      // Si une exception se produit, envoyer une réponse JSON avec l'erreur
      JsonResponse := TJSONObject.Create;
      JsonResponse.Add('success', 'FALSE'); // Succès = False
      //JsonResponse.Add('message', 'Erreur: ' + ); // Message d'erreur
      JsonResponse.Add('message', E.Message);
      // Envoyer la réponse JSON de l'erreur
      Response.Send(JsonResponse.AsJSON);
      JsonResponse.Free;
    end;
  end;
end;

procedure MiseAjourStagiaireController(Request: THorseRequest;
  Response: THorseResponse);
var
  id:string;
  Nom, Prenom, Email, Telephone, Message: string;
  Success: string;
  JSONData: TJSONData;
  JSONStr: string;
  JsonResponse: TJSONObject; // Utilisation de fpjson.TJSONObject
begin
  try
    // Récupérer le corps de la requête sous forme de chaîne de caractères
    JSONStr := Request.Body;

    // Analyser la chaîne JSON directement avec fpjson
    JSONData := GetJSON(JSONStr); // Utilisation de GetJSON pour analyser le JSON

    // Extraction des champs JSON
    id := JSONData.FindPath('id').AsString;
    Nom := JSONData.FindPath('nom').AsString;
    Prenom := JSONData.FindPath('prenom').AsString;
    Email := JSONData.FindPath('email').AsString;
    Telephone := JSONData.FindPath('telephone').AsString;

    // Appel à la méthode du DataModule
    //DM.MiseAjourStagiaire(id,Nom, Prenom, Email, Telephone, Message, Success);
     DM.MiseAjourEntity('mettre_a_jour_stagiaire',  ['id',ID,'nom', Nom, 'prenom', Prenom, 'email', Email, 'telephone', Telephone], Message, Success);

    // Créer la réponse JSON avec fpjson
    JsonResponse := TJSONObject.Create;
    JsonResponse.Add('success', Success); // Utilisation de TJSONBoolean
    JsonResponse.Add('message', Message); // Ajouter le message

    // Envoyer la réponse JSON sous forme de chaîne
    Response.Send(JsonResponse.AsJSON); // Utiliser AsJSON pour convertir en chaîne
  except
    on E: Exception do
    begin
      // Si une exception se produit, envoyer une réponse JSON avec l'erreur
      JsonResponse := TJSONObject.Create;
      JsonResponse.Add('success', 'FALSE'); // Succès = False
      //JsonResponse.Add('message', 'Erreur: ' + E.Message); // Message d'erreur
      JsonResponse.Add('message', 'Duplication Email');
      // Envoyer la réponse JSON de l'erreur
      Response.Send(JsonResponse.AsJSON);
      JsonResponse.Free;
    end;
  end;

end;

procedure SuprimerStagiaireController(Request: THorseRequest; Response: THorseResponse);
var
  id:string;
  Success: string;
  Message : string;
  JsonResponse: TJSONObject; // Utilisation de fpjson.TJSONObject
begin
  try
    // Récupérer le corps de la requête sous forme de chaîne de caractères
    id := Request.Params['id'];
    // Appel à la méthode du DataModule
    //DM.SuprimerStagiaire(id, Message, Success);
      DM.SupprimerEntity('supprimer_stagiaire', ID, Message, Success);

    // Créer la réponse JSON avec fpjson
    JsonResponse := TJSONObject.Create;
    JsonResponse.Add('success', Success); // Utilisation de TJSONBoolean
    JsonResponse.Add('message', Message); // Ajouter le message
      Response.ContentType('application/json');
    // Envoyer la réponse JSON sous forme de chaîne
    Response.Send(JsonResponse.AsJSON); // Utiliser AsJSON pour convertir en chaîne
  except
    on E: Exception do
    begin
      // Si une exception se produit, envoyer une réponse JSON avec l'erreur
      JsonResponse := TJSONObject.Create;
      JsonResponse.Add('success', 'FALSE'); // Succès = False
      //JsonResponse.Add('message', 'Erreur: ' + E.Message); // Message d'erreur
      JsonResponse.Add('message',  E.Message);
      // Envoyer la réponse JSON de l'erreur
      Response.Send(JsonResponse.AsJSON);
      JsonResponse.Free;
    end;
 end;
end;

procedure AllStagiaireController(Request: THorseRequest;Response: THorseResponse);
var
  Success, Message: string;
  JsonResponse: TJSONObject;
  JSONArray: TJSONArray;
begin
  try

    // Initialiser le tableau JSON
    JSONArray := TJSONArray.Create;
      // Initialiser la réponse JSON
    JSONArray:= DM.AllEntity('all_stagiaire', Message, Success);
    JsonResponse := TJSONObject.Create;
    JsonResponse.Add('success', Success);
    JsonResponse.Add('message', Message);

    // Ajouter le tableau à la réponse
    JsonResponse.Add('data', JSONArray);
    Response.ContentType('application/json');
    // Envoyer la réponse JSON
    Response.Send(JsonResponse.AsJSON);

  except
    on E: Exception do
    begin
      // Gestion des erreurs
      JsonResponse := TJSONObject.Create;
      JsonResponse.Add('success', 'FALSE');
      JsonResponse.Add('message', E.Message);
      Response.Send(JsonResponse.AsJSON);
      JsonResponse.Free;
    end;
  end;

end;

end.

