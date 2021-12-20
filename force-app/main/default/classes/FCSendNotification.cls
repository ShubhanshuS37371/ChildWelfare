public class FCSendNotification
{
    @InvocableMethod
    public static void SendFCNotification(List <Id> UserIds)
    {
       String Message = 'You have been assigned a new Safety Assessment.';
       String userId = UserIds[0];
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