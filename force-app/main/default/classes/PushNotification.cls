global with sharing class PushNotification implements vlocity_ps.VlocityOpenInterface2 {
   global Object invokeMethod(String methodName,
      Map <String, Object> inputMap,
      Map <String, Object> outMap, Map <String, Object> options) {
      Boolean success = true;
      String errors = 'OK';
      try {
         if (methodName == 'sendMessage') {
            sendMessage(inputMap, outMap, options);
         } 
      } catch (Exception e) {
         System.debug('ERROR in PushNotification: ' + e.getStackTraceString());
         errors = e.getMessage();
         success = false;
      }
      outMap.put('success', success);
      outMap.put('error', errors);
      return success;
   }
    void sendMessage(Map<String, Object> inputMap, Map<String,Object> outputMap, Map<String, Object> optionsMap) {
       
       String Message = String.valueOf(optionsMap.get('MessageText'));
       
       String userId = String.valueOf(optionsMap.get('UserId'));
   
       Map<String, Object> applePayload =  Messaging.PushNotificationPayload.apple(Message, '', null, null);
       Map<String, Object> androidPayload = new Map<String, Object>();
       androidPayload.put('message', Message);
       Set<String> users = new Set<String>();
       users.add(userId);
       System.debug('userId= ' + userId);
       System.debug('message= ' + Message);
        
       vlocity_mobile.VlocityMobileNotification.send(applePayload, androidPayload, users);

    }
}