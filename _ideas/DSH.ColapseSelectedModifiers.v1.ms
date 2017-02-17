--------------------------------
 LB_GETCOUNT= 0x18B
 LB_GETSEL = 0x187
 
hwnd = (windows.getChildHWND #max "Command Panel")[1]
list_box = for c in windows.getChildrenHWND hwnd   where  c[4] == "ListBox" do exit with c[1]
	 
count = windows.SendMessage list_box LB_GETCOUNT 0 0
 
items = for i=0 to count-1 where (windows.SendMessage  list_box  LB_GETSEL i 0) == 1 collect (i+1)
-- get modifiers

for k in items collect (if k > $.modifiers.count then $.baseobject else $.modifiers[k])

---------------------------





rollout dial "Collapse Modifiers" (
	

	fn collapseSelectedMods obj = (
		if (classof obj == Editable_mesh) do (
			
		)
	)

	
	on dial open do (
				
	)
)


clearlistener()
createDialog dial