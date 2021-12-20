/**
 * This class exposes a method that can be invoked by Salesforce Process Builder.  It calls an Integration Procedure
 * that creates a Case from an Incident
 *
 * @author Jeremy Blankenship - adapted from code by Joe McMaster
 *
 * @version 1.0
 *
 * History
 * =======
 * 1.0 - Apr 3, 2019 - Initial Version (Email Sample)
 */
global with sharing class IntegrationProcedureAction {

    /**
     * This is a method that can be invoked by the Salesforce Process Builder.
     *
     * @param input  A list of input objects
     * 
     * @return A list of output objects
     */
    @InvocableMethod (label = 'Vlocity Integration Procedure - Create Case')
    global static List<IntegrationProcedureActionOutput> runIntegrationService(List<IntegrationProcedureActionInput> input) {
        
        System.debug('Calling Integration Procedure');
        System.debug('IP Name  = ' + input[0].procedureAPIName);
        System.debug('IP Input = ' + input[0]);
        
        // If the Integration Procedure makes external API callouts, you will need to call the @future method
        // This means it is executed asynchronously and this class will not be able to wait for the response or 
        // handle failure situations
        Map<String, String> i = new Map<String, String>();  // add any input
        i.put('incidentid', input[0].incidentid);
        
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
        
        //ipOutput = (Map <String, Object>) vlocity_ps.IntegrationProcedureService.runIntegrationService(input[0].procedureAPIName, ipInput, ipOptions);        
        
        //System.debug('IP Output: ' + ipOutput);
        
        // If the Integration Procedure does not make any external API callouts, you can execute it synchronously and
        // handle any response data/failures
        Object obj = vlocity_ps.IntegrationProcedureService.runIntegrationService(input[0].procedureAPIName, i, new Map<String, String>());
        // Handle any response data and map it to the response of this method   
        return new List<IntegrationProcedureActionOutput>();  
    }
    
    /**
     * Inner class that defined the input object for this action
     *
     */
    global class IntegrationProcedureActionInput {
        
        @InvocableVariable(label='Integration Procedure Type_Subtype')
        global String procedureAPIName;        

        @InvocableVariable(label='IncidentId')
        global String incidentid;
    }

    /**
     * Inner class that defines the output object for this action
     *
     */
    global class IntegrationProcedureActionOutput {
        
        @InvocableVariable(label='Output')
        global String output;
    }    
}