Use LogRhythm_KBDL
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDeploymentsForLicenseIDs]') AND type in (N'P', N'PC'))
  Drop Procedure [dbo].[GetDeploymentsForLicenseIDs]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DisableDeploymentsForLicenseIDs]') AND type in (N'P', N'PC'))
  Drop Procedure [dbo].[DisableDeploymentsForLicenseIDs]
GO


IF EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'MasterLicence_TableType')
--if (OBJECT_ID(N'dbo.MasterLicence_TableType') is not null)
begin 
  print N'Drop Type'
  drop Type dbo.MasterLicence_TableType;
end
go

CREATE TYPE [dbo].[MasterLicence_TableType] AS TABLE(
	[MasterLicenseID] [int] NOT NULL
);
go

IF EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'DeploymnetID_TableType')
begin 
  print N'Drop DeploymnetID_TableType'
  drop Type dbo.DeploymnetID_TableType;
end
go

CREATE TYPE [dbo].[DeploymnetID_TableType] AS TABLE(
	[DeploymentID] [int] NOT NULL
);
go

Grant Execute on Type::DeploymnetID_TableType to KBAdmin;
go

Create Procedure GetDeploymentsForLicenseIDs(@MasterLicenseIDList MasterLicence_TableType ReadOnly)
As
begin
  Begin Try
    Select DeploymentID, Created, Modified, Modifier, Deployment.MasterLicenseID, Name, IsAuthorized, Fingerprint, EnforceFingerprint, RequireSnapshot
    From Deployment Inner Join @MasterLicenseIDList list On list.MasterLicenseID = Deployment.MasterLicenseID;
  End Try
  Begin Catch
    Rollback Tran;
      DECLARE @ErrorMessage NVARCHAR(4000);
      DECLARE @ErrorSeverity INT;
      DECLARE @ErrorState INT;
      SELECT @ErrorMessage = ERROR_MESSAGE(), 
             @ErrorSeverity = ERROR_SEVERITY(), 
             @ErrorState = ERROR_STATE(); 

       -- Use RAISERROR inside the CATCH block to return error 
       -- information about the original error that caused 
       -- execution to jump to the CATCH block. 
       RAISERROR (@ErrorMessage, 
                  @ErrorSeverity,   
                  @ErrorState); 

      return 1; 
  end catch; 
  return 0; 
end;
go

Grant Execute on GetDeploymentsForLicenseIDs to KBSupport;
Grant Execute on GetDeploymentsForLicenseIDs to KBAdmin;
go

Create Procedure DisableDeploymentsForLicenseIDs(@DeploymnetIDList DeploymnetID_TableType ReadOnly)
As
begin
  Begin Try
    Begin Tran
      Update Deployment Set IsAuthorized=0
      From @DeploymnetIDList List Inner Join Deployment On list.DeploymentID = Deployment.DeploymentID;
    Commit Tran
  End Try
  Begin Catch
    Rollback Tran;
      DECLARE @ErrorMessage NVARCHAR(4000);
      DECLARE @ErrorSeverity INT;
      DECLARE @ErrorState INT;
      SELECT @ErrorMessage = ERROR_MESSAGE(), 
             @ErrorSeverity = ERROR_SEVERITY(), 
             @ErrorState = ERROR_STATE(); 

       -- Use RAISERROR inside the CATCH block to return error 
       -- information about the original error that caused 
       -- execution to jump to the CATCH block. 
       RAISERROR (@ErrorMessage, 
                  @ErrorSeverity,   
                  @ErrorState); 

      return 1; 
  end catch; 
  return 0; 
end;
go

Grant Execute on DisableDeploymentsForLicenseIDs to KBAdmin;
go