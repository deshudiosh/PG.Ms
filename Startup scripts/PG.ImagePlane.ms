-- most of the code taken from https://forums.cgsociety.org/t/get-filename-of-file-being-drag-dropped-on-the-viewport/1526810/6

global WindowHooker
fn CreateDropFileHooker forceRecompile:on = if forceRecompile do ( 
	source = ""
	source += "using System;\n"
	source += "using System.Runtime.InteropServices;\n"
	source += "using System.Text;\n"
	source += "using System.Windows.Forms;\n"
	source += "public class DropFileHooker : NativeWindow\n"
	source += "{\n"
	source += "	private const int WM_DROPFILES = 0x0233;\n"
	source += "	private const int MAX_PATH = 260;\n"
	source += "	public DropFileHooker() { }\n"
	source += "	public class MessageEventArgs : EventArgs\n"
	source += "	{\n"
	source += "		public MessageEventArgs(Message message, string [] files)\n"
	source += "		{\n"
	source += "			Message = message;\n"
	source += "			Files = files;\n"
	source += "			Handled = false;\n"
	source += "		}\n"
	source += "		public readonly Message Message;\n"
	source += "		public readonly string[] Files;\n"
	source += "		public bool Handled = false;\n"
	source += "	}\n"
	source += "	public event EventHandler MessageReceived;\n"
	source += "	protected override void WndProc(ref Message message)\n"
	source += "	{\n"
	source += "		switch (message.Msg)\n"
	source += "		{\n"
	source += "			case WM_DROPFILES:\n"
	source += "				IntPtr hDrop = message.WParam;\n"
	source += "				//string FileName = null;\n"
	source += "				uint FilesDropped = DragQueryFile(hDrop, -1, null, 0);\n"
	source += "				string[] Files = new string[FilesDropped];\n"
	source += "				if (FilesDropped != 0)\n"
	source += "				{\n"
	source += "					StringBuilder sFileName = new StringBuilder(MAX_PATH);\n"
	source += "					for (int i = 0; i < FilesDropped; i++)\n"
	source += "					{\n"
	source += "						DragQueryFile(hDrop, i, sFileName, MAX_PATH);\n"
	source += "						Files[i] = sFileName.ToString().ToLower();\n"
	source += "					}\n"
	source += "				}\n"
	source += "				MessageEventArgs arg = new MessageEventArgs(message, Files);\n"
	source += "				MessageReceived(this, arg);\n"
	source += "				if (arg.Handled)\n"
	source += "				{\n"
	source += "					DragFinish(hDrop);\n"
	source += "				}\n"
	source += "				break;\n"
	source += "			default:\n"
	source += "				break;\n"
	source += "		}\n"
	source += "		base.WndProc(ref message);\n"
	source += "	}\n"
	source += "	[DllImport(\"shell32.dll\")]\n"
	source += "	static extern uint DragQueryFile(IntPtr hDrop, int iFile, [Out] StringBuilder lpszFile, uint cch);\n"
	source += "	[DllImport(\"shell32.dll\")]\n"
	source += "	static extern uint DragFinish(IntPtr hDrop);\n"
	source += "}\n"
 
 	csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
 	compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
 
 	compilerParams.ReferencedAssemblies.AddRange #("System.dll", "System.Windows.Forms.dll")
 
 	compilerParams.GenerateInMemory = true
 	compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
 		
 	WindowHooker = compilerResults.CompiledAssembly
 )
 CreateDropFileHooker()
 
 (
	fn createplane imgpath = (
		p = plane()
		mat = standardmaterial()
		bt = Bitmaptexture ()
		bt.filename = imgpath
		mat.diffuseMap = bt
		p.material = mat
		showTextureMap mat on
		p.width = p.length * (bt.bitmap).width as float/(bt.bitmap).height
	)
	 	 
 	global hooker = WindowHooker.createInstance "DropFileHooker"
 	fn onMessageReceived s e =
 	(
		file = e.files[1]
		type = getFilenameType e.files[1]
		
		if type == ".jpg" or type == ".png" do (
 		--format "here: %\n" e.files
			createplane (e.files[1])
			if e.files.count > 1 do e.Handled = on
		)
 	)
 	dotnet.removeAllEventHandlers hooker
 	dotnet.addEventHandler hooker "MessageReceived" onMessageReceived
 	
 	hooker.ReleaseHandle() -- DON'T FORGET TO RELEASE
 	hooker.AssignHandle (dotnetobject "IntPtr" (windows.getMAXHWND()))
 )