BEGIN TRY
    BEGIN TRANSACTION 
        exec( @sqlHeader)
        exec(@sqlTotals)
        exec(@sqlLine)
    COMMIT
END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH