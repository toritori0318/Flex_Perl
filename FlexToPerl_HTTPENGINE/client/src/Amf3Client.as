package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    
    import mx.collections.ArrayCollection;

    public class Amf3Client {
        private var nc:NetConnection = new NetConnection();
        private var _view:FlexToPerl;
        private var _gatewayURL:String = "http://localhost:3000/gateway3";

       public function Amf3Client(view:FlexToPerl = null)
        {
           if (view){
               _view = view;
            }
            nc.objectEncoding = ObjectEncoding.AMF0;
            nc.addEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler );
            nc.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            nc.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
            nc.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorEvent );
        }

       public function get view():FlexToPerl{
            return _view;
        }
        public function amf3Request():void {
/*            nc.connect(_gatewayURL);
            nc.call("echo", new Responder(echoResult, remoteError), "foo", "bar");
            nc.call("sum", new Responder(sumResult, remoteError), 1, 1);
            
            var _ary:Object = new Object;
		     _ary.emp_name = _view.emp_name.text;
            nc.call("list", new Responder(listResult, remoteError), _ary);
*/        }

        private function echoResult(...args):void {
        	_view.remote_text.text += '\necho_result:';
        	_view.remote_text.text += args;
        }

        private function sumResult(...args):void {
        	_view.remote_text.text += '\nsum_result:';
        	_view.remote_text.text += args;
        }
        private function listResult(result:*):void {
        	// Empテーブルのハッシュ
        	var _result:Array = result as Array;
        	var _dp:ArrayCollection = new ArrayCollection;
			for (var i:int =0; i<_result.length;i++){
	    		var _item:Object = _result[i];
	    		_dp.addItem(_item);	
			}
			view.dg.dataProvider = _dp;
        }
        
        private function remoteError(...args):void {
        	_view.remote_text.text += 'remote_error:';
        	_view.remote_text.text += args;
        }

        private function asyncErrorHandler(e:AsyncErrorEvent):void {}
        private function ioErrorHandler(e:IOErrorEvent):void {}
        private function netStatusHandler(e:NetStatusEvent):void {}
        private function securityErrorEvent(e:SecurityErrorEvent):void {}
    }
}