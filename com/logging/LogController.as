package com.logging
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Provides control over application logging.
	 * @author Jared Riley
	 */
	public class LogController
	{
		/**
		 * The current log level to be output. Entries below this level will be ignored.
		 */
		private static var _logLevel:uint = 0;
		
		/**
		 * Helper constants indicating different severity levels.
		 */
		private static const INFO:uint = 0;
		private static const WARNING:uint = 1;
		private static const ERROR:uint = 2;
		private static const NONE:uint = 4;
		
		/**
		 * Ignores all log entries submitted to the logger. Errors will still be thrown if logged.
		 */
		public static function HideAllLogs():void
		{
			_logLevel = NONE;
		}
		
		/**
		 * Displays all log entires submitted to the logger.
		 */
		public static function ShowAllLogs():void
		{
			_logLevel = INFO;
		}
		
		/**
		 * Ignores 'Info' log entries submitted to the logger.
		 */
		public static function ShowWarningsAndErrors():void
		{
			_logLevel = WARNING;
		}
		
		/**
		 * All log entries except Errors will be ignored by the logger.
		 */
		public static function ShowErrorsOnly():void
		{
			_logLevel = ERROR;
		}
		
		/**
		 * Processes a low severity "Info" level log entry.
		 * @param	object The object making the log request.
		 * @param	message The message provided to be logged.
		 */
		public static function LogInfo(object:Object, message:String):void
		{
			ProcessLog(object, message, INFO);
		}
		
		/**
		 * Processes a medium severity "Warning" level log entry.
		 * @param	object The object making the log request.
		 * @param	message The message provided to be logged.
		 */
		public static function LogWarning(object:Object, message:String):void
		{
			ProcessLog(object, message, WARNING);
		}
		
		/**
		 * Throws an Error and processes a high severity "Error" level log entry.
		 * @param	object The object making the log request.
		 * @param	message The message provided to be logged.
		 */
		public static function LogError(object:Object, message:String):void
		{
			ProcessLog(object, message, ERROR);
		}
		
		/**
		 * The business end of the logger. Processes log requests and outputs them.
		 * @param	object The object making the log request.
		 * @param	message The message provided to be logged.
		 * @param	severity The severity of the log entry.  Errors will be thrown.
		 */
		private static function ProcessLog(object:Object, message:String, severity:uint = 0)
		{
			// Only display appropriate logs requested.
			if (severity < _logLevel)
			{
				// Still throw errors to halt execution.
				if (severity == 2)
				{
					throw new Error(message);
				}
				return;
			}
			
			var severityLabel:String = "";
			switch(severity)
			{
				case 0:
					severityLabel = "[Info] ";
					break;
					
				case 1:
					severityLabel = "[Warning] ";
					break;
					
				case 2:
					severityLabel = "[ERROR] ";
					break;
			}
			
			// Don't append a line number if only an Info log entry.
			var lineNumber:String = "";
			if (severity > 0)
			{
				lineNumber = ":" + (new Error().getStackTrace()).match(/(?<=:)[0-9]*(?=])/g)[2];
			}
			
			var logEntry:String = severityLabel + "[" + getQualifiedClassName(object) + lineNumber + "] " + message;
			
			// channel output to desired destinations.  In this case, just trace()
			OutputTrace(logEntry);
			
			// If an error, throw the Error
			if (severity == 2)
			{
				throw new Error(message);
			}
		}
		
		/**
		 * Outputs a log entry to the standard trace() method.
		 * @param	logEntry The message to be output to the trace console.
		 */
		private static function OutputTrace(logEntry:String):void
		{
			trace(logEntry);
		}
	}
	
}