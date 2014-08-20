package;
import extensionkit.ExtensionKit;
import extensionkit.event.ExtensionKitTestEvent;
import flash.display.Stage;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class PubnubExtenion {
	
	public static function Initialize() : Void
    {
        ExtensionKit.Initialize();
        
    }
	public static var stage(get, never) : Stage;
	private static function get_stage() : Stage
    {
        return flash.Lib.current.stage;
    }
	
	public static function TriggerTestEvent ():Void {
		
		
		#if android
        // Add second listener as android will send event via both JNI and native code
        stage.addEventListener(ExtensionKitTestEvent.TEST_JNI, TraceReceivedTestEvent);
        pubnubextenion_TriggerTestEvent_jni();
        #end

        stage.addEventListener(ExtensionKitTestEvent.TEST_NATIVE, TraceReceivedTestEvent);
		
	}
	 private static function TraceReceivedTestEvent(e:ExtensionKitTestEvent) : Void
    {
        trace(e);
        stage.removeEventListener(e.type, TraceReceivedTestEvent);
    }
	
	public static function sampleMethod (inputValue:Int):Int {
		
		#if (android && openfl)
		
		var resultJNI = pubnubextenion_sample_method_jni(inputValue);
		var resultNative = pubnubextenion_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative;
		
		#else
		
		return pubnubextenion_sample_method(inputValue);
		
		#end
		
	}
	
	
	private static var pubnubextenion_sample_method = Lib.load ("pubnubextenion", "pubnubextenion_sample_method", 1);
	//private static var pubnubextenion_TriggerTestEvent = Lib.load ("pubnubextenion", "pubnubextenion_TriggerTestEvent", 0);
	
	#if (android && openfl)
	
	
	private static var pubnubextenion_TriggerTestEvent_jni = JNI.createStaticMethod ("org.haxe.extension.PubnubExtenion", "TriggerTestEvent", "()V");
	private static var pubnubextenion_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.PubnubExtenion", "sampleMethod", "(I)I");
	
	#end
	
	
	
}