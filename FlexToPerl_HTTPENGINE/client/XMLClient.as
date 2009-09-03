package {
    import mx.rpc.http.HTTPService;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.controls.Alert;
    
    public class XMLClient {
        private var service: HTTPService = new HTTPService();
        private var _view:FlexToPerl;
        private var _gatewayURL:String = "http://localhost:3000/xml";

        public function XMLClient(view:FlexToPerl = null)
         {
            if (view){
               _view = view;
             }
            service.url = _gatewayURL;
            service.addEventListener(ResultEvent.RESULT, xmlResult);
            service.addEventListener(FaultEvent.FAULT,  xmlFault);
         }

        public function get view():FlexToPerl{
            return _view;
         }
        public function xmlRequest():void {
            var _prm:Object = new Object();
             _prm.emp_name = _view.emp_name.text;
             service.send(_prm);
         }
        private function xmlResult( event:ResultEvent ) : void {
             _view.dg.dataProvider = service.lastResult.Result.record;
         }
        private function xmlFault(event:FaultEvent):void {
            Alert.show('xmlFalut:'+event.message.toString());
         }
    }
}