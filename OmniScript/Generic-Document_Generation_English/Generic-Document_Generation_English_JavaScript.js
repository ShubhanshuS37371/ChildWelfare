baseCtrl.prototype.onSelectItemCustomized = function(control, option, index, scp, bFlip)
        {
            if(control === undefined || control === null || option === undefined || option === null)
                return;
            // multi-select, single select
            var bSetVal = true;
            var response = [];
            if(bFlip)
            {
                if(option.vlcSelected === undefined || option.vlcSelected === null)
                {
                    option.vlcSelected = bSetVal;
                }
                else
                {
                    bSetVal = !option.vlcSelected;
                    option.vlcSelected = bSetVal;
                }
            }

            // update 'Selectable Items' response
            var recSet = control.vlcSI[control.itemsKey];
            // HP bug, use $$hashKey to check
            for(var i=0; i<recSet.length; i++)
            {
                if(option.$$hashKey !== recSet[i].$$hashKey && bFlip && bSetVal && control.propSetMap.selectMode === 'Single')
                     recSet[i].vlcSelected = false;
                if(recSet[i].vlcSelected === true)
                {
                    recSet[i].Status = 'Inactive';
                    response.push(recSet[i]);
                }
            }

            if(response.length > 0)
                control.response = response;
            else
                control.response = null;

            if(control.propSetMap.dataJSON === true)
                scp.aggregate(scp, control.index, control.indexInParent, true, -1);
        };


  baseCtrl.prototype.setIPScope = function(scp)
{
    window.VlocOmniSI = scp;
    var afterSlash = '/' + window.location.href.split('.com/')[1].split('/')[0];
    if (afterSlash === 'apex') {
        afterSlash = '';
    }
   scp.applyCallResp({'urlPrefix':window.location.origin + afterSlash});
}

    window.top.addEventListener('message', function(event){
             if(event.data && event.data.constructor===Object && event.data.hasOwnProperty("docGenAttachmentId") ){
                   window.VlocOmniSI.applyCallResp(event.data);
              }
               if(event.data && event.data.constructor===Object && event.data.hasOwnProperty("docGenContentVersionId") ){
                   window.VlocOmniSI.applyCallResp(event.data);
               }
    }, false);