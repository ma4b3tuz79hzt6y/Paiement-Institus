unit StagiaireController;

interface

uses

  Horse, DataModule, SysUtils, fpjson, jsonparser;

procedure AjouterStagiaireController(Request: THorseRequest; Response: THorseResponse);
procedure MiseAjourStagiaireController(Request: THorseRequest; Response: THorseResponse);
procedure SuprimerStagiaireController(Request: THorseRequest; Response: THorseResponse) ;

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
    DM.AjouterStagiaire(Nom, Prenom, Email, Telephone, Message, Success);

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
    DM.MiseAjourStagiaire(id,Nom, Prenom, Email, Telephone, Message, Success);

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
  JSONData: TJSONData;
  JSONStr: string;
  JsonResponse: TJSONObject; // Utilisation de fpjson.TJSONObject
begin
  try
    // Récupérer le corps de la requête sous forme de chaîne de caractères
    id := Request.Params['id'];
    // Appel à la méthode du DataModule
    DM.SuprimerStagiaire(id, Message, Success);

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
      JsonResponse.Add('message',  E.Message);
      // Envoyer la réponse JSON de l'erreur
      Response.Send(JsonResponse.AsJSON);
      JsonResponse.Free;
    end;
 end;
end;

end.

