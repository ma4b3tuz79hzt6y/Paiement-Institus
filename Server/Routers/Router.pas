unit Router;
  {$MODE DELPHI}{$H+}
interface

uses
  Horse, StagiaireController;

procedure RegisterRoutes;

implementation

procedure RegisterRoutes;
begin
  // Route pour ajouter un stagiaire
  THorse.Post('/ajouter_stagiaire', AjouterStagiaireController);
  THorse.Post('/modifier_stagiaire', MiseAjourStagiaireController);
  THorse.Delete('/supprimer_stagiaire/:id', SuprimerStagiaireController);
end;

end.

