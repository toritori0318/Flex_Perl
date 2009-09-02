package
{
public class PerlClient extends ServiceClientBase implements IServiceClient
{
	public function PerlClient(view:HelloWorldPerl)
	{
		super(view);
	}

	override public function get gatewayUrl():String
	{
		return "http://localhost:" + gatewayPort + "/gateway";
	}

	override public function get gatewayPort():int
	{
		return 3000;
	}
	
	override public function get serviceName():String
	{
		return "echo";
	}		
}
}