unit inscriptionController;

{$mode Delphi}

interface

uses
  Classes,Horse, DataModule, SysUtils, fpjson, jsonparser;
procedure AjouterInscriptionController(Request: THorseRequest; Response: THorseResponse);
procedure AllInscriptionController(Request: THorseRequest; Response: THorseResponse) ;
implementation
 procedure AjouterInscriptionController(Request: THorseRequest; Response: THorseResponse);
var
  date_inscription :  string;
  nombre_echeance, filiere_id, annee_id,stagiaire_id : string;
  Message: string;
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
    date_inscription :=JSONData.FindPath('date_inscription').AsString;
    nombre_echeance := JSONData.FindPath('nombre_echeance').AsString;
    filiere_id := JSONData.FindPath('filiere_id').AsString;
      annee_id := JSONData.FindPath('annee_id').AsString;
      stagiaire_id := JSONData.FindPath('stagiaire_id').AsString;

    // Appel à la méthode du DataModule
    //DM.AjouterStagiaire(Nom, Prenom, Email, Telephone, Message, Success);
DM.AjouterEntity('AjouterInscription',
                          ['date_inscription', date_inscription,
                          'nombre_echeance',nombre_echeance,
                          'filiere_id',filiere_id,
                          'annee_id', annee_id,
                          'stagiaire_id',stagiaire_id],
                          Message, Success);

   // date_inscription, nombre_echeance, filiere_id, annee_id, stagiaire_id

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

 procedure AllInscriptionController(Request: THorseRequest; Response: THorseResponse
   );
 var
  Success, Message: string;
  JsonResponse: TJSONObject;
  JSONArray: TJSONArray;
begin
  try

    // Initialiser le tableau JSON
    JSONArray := TJSONArray.Create;
      // Initialiser la réponse JSON
    JSONArray:= DM.AllEntity('all_inscriptions', Message, Success);
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

