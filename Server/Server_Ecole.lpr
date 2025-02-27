program Server_Ecole;
  {$MODE DELPHI}{$H+}  
uses
 cthreads, SysUtils, Horse, Horse.Jhonson,Router, DataModule, {$IFDEF UNIX}BaseUnix{$ENDIF};

procedure Runing(horse:thorse);
    begin
      WriteLn('Server running on port: 9000');

    end;
begin
    // Initialisation du DataModule
    DM := TDM.Create(nil);
    // Enregistrement des routes
    RegisterRoutes;
    // Démarrer le serveur Horse
    //THorse.OnListen := @Runing;
    // Pour Linux, assurez-vous d'utiliser un port non réservé comme 8080
   THorse.Listen(9000,@Runing);
   // Le serveur écoute sur le port 9000

end.

