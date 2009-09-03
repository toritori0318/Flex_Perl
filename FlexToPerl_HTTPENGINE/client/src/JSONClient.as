package {
    import mx.rpc.http.HTTPService;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.controls.Alert;
    
    import com.adobe.serialization.json.JSONDecoder;
    
    public class JSONClient {
        private var service: HTTPService = new HTTPService();
        private var _view:FlexToPerl;
        private var _gatewayURL:String = "http://localhost:3000/json";

        public function JSONClient(view:FlexToPerl = null)
         {
            if (view){
               _view = view;
             }
            service.url = _gatewayURL;
            service.addEventListener(ResultEvent.RESULT, jsonResult);
            service.addEventListener(FaultEvent.FAULT,  jsonFault);
         }

        public function get view():FlexToPerl{
            return _view;
         }
        public function jsonRequest():void {
            var _prm:Object = new Object();
             _prm.emp_name = _view.emp_name.text;
             service.send(_prm);
         }
        private function jsonResult( event:ResultEvent ) : void {
             var data:String = event.result.toString();
             data = data.replace( /\s/g, '' );
             var jd:JSONDecoder = new JSONDecoder( data );
             _view.dg.dataProvider = jd.getValue();
         }
        private function jsonFault(event:FaultEvent):void {
            Alert.show('jsonFalut:'+event.message.toString());
         }
    }
}