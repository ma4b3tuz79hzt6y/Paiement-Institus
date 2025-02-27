unit Router;
  {$MODE DELPHI}{$H+}
interface

uses
  Horse, StagiaireController,FiliereController,inscriptionController;

procedure RegisterRoutes;

implementation

procedure RegisterRoutes;
begin
  // Route pour ajouter un stagiaire
  THorse.Post('/stagiaire', AjouterStagiaireController);
  THorse.Put('/stagiaire', MiseAjourStagiaireController);
  THorse.Delete('/stagiaire/:id', SuprimerStagiaireController);
  THorse.Get('/stagiaire', AllStagiaireController);

  THorse.Post('/filiere', AjouterFiliereController);
  THorse.Put('/filiere', MiseAjourFiliereController);
  THorse.Delete('/filiere/:id', SuprimerSFiliereController);
  THorse.Get('/filiere', AllFilierController);

  THorse.Post('/inscription', AjouterInscriptionController());
  THorse.get('/inscription', AllInscriptionController);
end;

end.

