global with sharing class DemoReset implements vlocity_ps.VlocityOpenInterface2 {
   global Object invokeMethod(String methodName,
      Map <String, Object> inputMap,
      Map <String, Object> outMap, Map <String, Object> options) {
      Boolean success = true;
      String errors = 'OK';
      try {
         if (methodName == 'deleteDemoData') {
            deleteDemoData(inputMap, outMap, options);
         } 
      } catch (Exception e) {
         System.debug('ERROR in DemoReset: ' + e.getStackTraceString());
         errors = e.getMessage();
         success = false;
      }
      outMap.put('success', success);
      outMap.put('error', errors);
      return success;
   }
    void deleteDemoData(Map<String, Object> inputMap, Map<String,Object> outputMap, Map<String, Object> optionsMap) {
        if (inputMap.containsKey('idsToDelete')) {
            List<Id> idsToDelete = new List<Id>();
            List<Object> idList = (List<Object>) inputMap.get('idsToDelete');
            for (Object idString : idList) {
                if (idString != null) {
                    Id id = (Id) idString;
                    idsToDelete.add(id);
                }
            }
 
            Database.delete(idsToDelete, false);
        }
    }
}