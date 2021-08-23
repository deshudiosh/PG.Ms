--script found at:
--https://knowledge.autodesk.com/support/3ds-max/troubleshooting/caas/sfdcarticles/sfdcarticles/How-to-make-Isolated-Xref-objects-visible-in-3ds-Max-2017.html

struct QuickIsolateDef (
	private
	hiddenNodes = #(),
	hiddenLayers = #(),
	public
	fn QuickIsolate =
	(
		for o in objects where not o.ishidden and not o.isSelected do (hide o;append hiddenNodes o)
		local nxrefs = xrefs.getXRefFileCount()
		for i = 1 to nxrefs do
		(
			local xref_f = xrefs.getXRefFile i
			if xref_f.hidden do (xref_f.hidden = false; append hiddenLayers xref_f)
		)
		ok
	),
	fn QuickUnIsolate =
	(
		for o in hiddenNodes where isvalidnode o do unhide o
		for xref_f in hiddenLayers where not isDeleted xref_f do xref_f.hidden = false
		hiddenNodes = #()
		hiddenLayers = #()
	)
)
QuickIsolate = QuickIsolateDef()