XCODE?="/Applications/Xcode.app"
PLUGINDIR="Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
CLANG_PLUGIN="Clang LLVM 1.0.xcplugin"
CLANG_XCSPEC="Contents/Resources/Clang LLVM 1.0.xcspec"
PLISTBUDDY=/usr/libexec/PlistBuddy
UUID=`defaults read $(XCODE)/Contents/Info DVTPlugInCompatibilityUUID`
BUILD=`defaults read $(XCODE)/Contents/Info DTXcodeBuild`
LIBRARY_PLUGIN_DIR="/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
MPICC_PLUGIN="Build/MPICC (Clang) $(BUILD).xcplugin"
NVCC_PLUGIN="Build/NVCC $(BUILD).xcplugin"
GCC72_PLUGIN="Build/GCC 7.2 $(BUILD).xcplugin"
GCC49_PLUGIN="Build/GCC 4.9 $(BUILD).xcplugin"

define add_uuid
	plutil -convert xml1 $(1)/Contents/Info.plist
	${PLISTBUDDY} -c "Add DVTPlugInCompatibilityUUIDs array" $(1)/Contents/Info.plist    
	${PLISTBUDDY} -c "Add DVTPlugInCompatibilityUUIDs:0 string $(UUID)" $(1)/Contents/Info.plist
endef

mpicc-clang:
	mkdir -p Build
	rm -Rf $(MPICC_PLUGIN)
	cp -R $(XCODEAPP)/$(PLUGINDIR)/$(CLANG_PLUGIN) $(MPICC_PLUGIN)
	rm -Rf $(MPICC_PLUGIN)/Contents/_CodeSignature
	rm -Rf $(MPICC_PLUGIN)/Contents/MacOS
	rm $(MPICC_PLUGIN)/Contents/Resources/"Default Compiler.xcspec"
	rm $(MPICC_PLUGIN)/Contents/Resources/English.lproj/"Default Compiler.strings"
	sed -i -- 's/com\.apple\.compilers\.llvm\.clang\.1_0/compilers\.mpicc\.clang/g' $(MPICC_PLUGIN)/$(CLANG_XCSPEC)
	sed -i -- 's/ExecCPlusPlusLinkerPath = "clang++";/ExecCPlusPlusLinkerPath = "mpicxx";/g' $(MPICC_PLUGIN)/$(CLANG_XCSPEC)
	sed -i -- 's/ExecPath = "clang";/ExecPath = "mpicxx";/g' $(MPICC_PLUGIN)/$(CLANG_XCSPEC)
	python replace.py $(MPICC_PLUGIN)/$(CLANG_XCSPEC) "(Apple LLVM \d\.\d)" "MPICC (\1)"
	$(call add_uuid,$(MPICC_PLUGIN))
	sed -i -- 's/com\.apple\.compilers\.llvm\.clang\.1_0/compilers\.mpicc\.clang/g' $(MPICC_PLUGIN)/Contents/Info.plist
	sed -i -- 's/com\.apple\.compilers\.clang/compilers\.mpicc\.clang/g' $(MPICC_PLUGIN)/Contents/Info.plist
	sed -i -- 's/Clang LLVM 1\.0 Compiler Xcode Plug-in/MPICC \(Clang LLVM 1\.0\) Compiler Xcode Plug-in/g' $(MPICC_PLUGIN)/Contents/Info.plist
	python rename.py $(MPICC_PLUGIN)/Contents/Resources/English.lproj '(.*)\.strings' 'MPICC (\1).strings' -w


install-mpicc-clang:
	mkdir -p $(LIBRARY_PLUGIN_DIR)
	cp -R $(MPICC_PLUGIN) $(LIBRARY_PLUGIN_DIR)

nvcc:
	mkdir -p Build
	rm -Rf $(NVCC_PLUGIN)
	cp -R "NVCC.xcplugin" $(NVCC_PLUGIN)
	$(call add_uuid,$(NVCC_PLUGIN))

install-nvcc:
	mkdir -p $(LIBRARY_PLUGIN_DIR)
	cp -R $(NVCC_PLUGIN) $(LIBRARY_PLUGIN_DIR)

gcc-72:
	mkdir -p Build
	rm -Rf $(GCC72_PLUGIN)
	cp -R "GCC 7.2.xcplugin" $(GCC72_PLUGIN)
	$(call add_uuid,$(GCC72_PLUGIN))


install-gcc-72:
	mkdir -p $(LIBRARY_PLUGIN_DIR)
	cp -R $(GCC72_PLUGIN) $(LIBRARY_PLUGIN_DIR)

gcc-49:
	mkdir -p Build
	rm -Rf $(GCC72_PLUGIN)
	cp -R "GCC 4.9.xcplugin" $(GCC49_PLUGIN)
	$(call add_uuid,$(GCC49_PLUGIN))

install-gcc-49:
	mkdir -p $(LIBRARY_PLUGIN_DIR)
	cp -R $(GCC49_PLUGIN) $(LIBRARY_PLUGIN_DIR)

