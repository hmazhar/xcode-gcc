export XCODEAPP="/Applications/Xcode.app"
PLUGINDIR="Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
CLANG_PLUGIN="Clang LLVM 1.0.xcplugin"
MPICC_PLUGIN="MPICC (Clang).xcplugin"
XCSPEC="Contents/Resources/Clang LLVM 1.0.xcspec"
PLISTBUDDY=/usr/libexec/PlistBuddy
UUID=`defaults read $(XCODEAPP)/Contents/Info DVTPlugInCompatibilityUUID`
BUILD=`defaults read $(XCODEAPP)/Contents/Info DTXcodeBuild`
MPICC_PLUGIN="MPICC (Clang) $(BUILD).xcplugin"
LIBRARY_PLUGIN_DIR="/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
NVCC_PLUGIN="NVCC.xcplugin"

mpicc-clang:
	rm -Rf $(MPICC_PLUGIN)
	cp -R $(XCODEAPP)/$(PLUGINDIR)/$(CLANG_PLUGIN) $(MPICC_PLUGIN)
	rm -Rf $(MPICC_PLUGIN)/Contents/_CodeSignature
	rm -Rf $(MPICC_PLUGIN)/Contents/MacOS
	rm $(MPICC_PLUGIN)/Contents/Resources/"Default Compiler.xcspec"
	rm $(MPICC_PLUGIN)/Contents/Resources/English.lproj/"Default Compiler.strings"
	sed -i -- 's/com\.apple\.compilers\.llvm\.clang\.1_0/compilers\.mpicc\.clang/g' $(MPICC_PLUGIN)/$(XCSPEC)
	sed -i -- 's/ExecCPlusPlusLinkerPath = "clang++";/ExecCPlusPlusLinkerPath = "mpicxx";/g' $(MPICC_PLUGIN)/$(XCSPEC)
	sed -i -- 's/ExecPath = "clang";/ExecPath = "mpicxx";/g' $(MPICC_PLUGIN)/$(XCSPEC)
	python replace.py $(MPICC_PLUGIN)/$(XCSPEC) "(Apple LLVM \d\.\d)" "MPICC (\1)"
	plutil -convert xml1 $(MPICC_PLUGIN)/Contents/Info.plist
	sed -i -- 's/com\.apple\.compilers\.llvm\.clang\.1_0/compilers\.mpicc\.clang/g' $(MPICC_PLUGIN)/Contents/Info.plist
	sed -i -- 's/com\.apple\.compilers\.clang/compilers\.mpicc\.clang/g' $(MPICC_PLUGIN)/Contents/Info.plist
	sed -i -- 's/Clang LLVM 1\.0 Compiler Xcode Plug-in/MPICC \(Clang LLVM 1\.0\) Compiler Xcode Plug-in/g' $(MPICC_PLUGIN)/Contents/Info.plist
	${PLISTBUDDY} -c "Add DVTPlugInCompatibilityUUIDs array" $(MPICC_PLUGIN)/Contents/Info.plist    
	${PLISTBUDDY} -c "Add DVTPlugInCompatibilityUUIDs:0 string $(UUID)" $(MPICC_PLUGIN)/Contents/Info.plist
	python rename.py $(MPICC_PLUGIN)/Contents/Resources/English.lproj '(.*)\.strings' 'MPICC (\1).strings' -w


install-mpicc-clang:
	mkdir -p $(LIBRARY_PLUGIN_DIR)
	cp -R $(MPICC_PLUGIN) $(LIBRARY_PLUGIN_DIR)

install-nvcc:
	mkdir -p $(LIBRARY_PLUGIN_DIR)
	#plutil -convert xml1 $(NVCC_PLUGIN)/Contents/Info.plist
	#${PLISTBUDDY} -c "Add DVTPlugInCompatibilityUUIDs array" $(NVCC_PLUGIN)/Contents/Info.plist    
	#${PLISTBUDDY} -c "Add DVTPlugInCompatibilityUUIDs:0 string $(UUID)" $(NVCC_PLUGIN)/Contents/Info.plist
	cp -R $(NVCC_PLUGIN) $(LIBRARY_PLUGIN_DIR)
