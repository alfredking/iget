#! /usr/bin/ruby -w

require 'xcodeproj'

def rmFilesRecursively(aTarget, aGroup)
    aGroup.files.each do |file|
        puts file.real_path.to_s
        if file.real_path.to_s.end_with?(".m",".mm",".cpp") then
            aTarget.source_build_phase.remove_file_reference(file)
        elsif file.real_path.to_s.end_with?(".plst",".bundle") then
            aTarget.resources_build_phase.remove_file_reference(file)
        elsif file.real_path.to_s.end_with?(".a") then
            aTarget.frameworks_build_phase.remove_file_reference(file)
        end
    end
    
    aGroup.groups.each do |group|
        rmFilesRecursively(aTarget, group)
    end
end

def addFilesToGroup(aProject, aTarget, aGroup)
    Dir.foreach(aGroup.real_path) do |entry|
        filePath = File.join(aGroup.real_path, entry)
        if !File.directory?(filePath) && entry != ".DS_Store" then
            # 向group中增加文件引用
            fileReference = aGroup.new_reference(filePath)
            # 如果不是头文件则继续增加到Build Phase中，PB文件需要加编译标志
            if filePath.to_s.end_with?("pbobjc.m", "pbobjc.mm") then
                aTarget.add_file_references([fileReference], '-fno-objc-arc')
            elsif filePath.to_s.end_with?(".m", ".mm", ".cpp") then
                aTarget.source_build_phase.add_file_reference(fileReference, true)
            elsif filePath.to_s.end_with?(".plist") then
                aTarget.resources_build_phase.add_file_reference(fileReference, true)
            elsif filePath.to_s.end_with?(".a") then
                aTarget.frameworks_build_phase.add_file_reference(fileReference, true)
            end
        elsif File.directory?(filePath) && filePath.to_s.end_with?(".bundle") then
            fileReference = aGroup.new_reference(filePath)
            aTarget.resources_build_phase.add_file_reference(fileReference)
        elsif File.directory?(filePath) && entry != '.' && entry != '..' && entry != '.svn' && entry != '.git' then
            hierarchy_path = aGroup.hierarchy_path[1, aGroup.hierarchy_path.length]
            subGroup = aProject.main_group.find_subpath(hierarchy_path + '/' + entry, true)
            subGroup.set_source_tree(aGroup.source_tree)
            subGroup.set_path(aGroup.real_path + entry)
            addFilesToGroup(aProject, aTarget, subGroup)

        end
    end
end

def addLIBFilesToFile(aLibFile, aFile)
    Dir.foreach(aLibFile) do |file|
        filePath = File.join(aLibFile, file)
        if file.to_s.end_with?(".h") || file.to_s.start_with?("libIDMPCMCC") then
            FileUtils.cp(filePath, aFile)
        end
    end
end
        

    

project_path = File.join(File.dirname(__FILE__), 'IDMPCMCCDemo.xcodeproj')
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

#删除旧的target下制定group的引用
group = project.main_group.find_subpath(File.join('IDMPMiddleWare-AlfredKing-CMCC','lib'))
if !group.empty? then
    rmFilesRecursively(target,group)
    group.clear()
end

groupFrame = project.main_group.find_subpath(File.join('Frameworks'))
if !groupFrame.empty? then
    rmFilesRecursively(target,groupFrame)
    groupFrame.clear()
end

#增加新的lib文件到指定目录文件夹下
lib_path = File.join('../IDMPCMCC','lib')
demo_lib_path = File.join('IDMPMiddleWare-AlfredKing-CMCC','lib')
addLIBFilesToFile(lib_path, demo_lib_path)

#增加新的lib文件到指定target的group中
addFilesToGroup(project, target, group)

#修改plist文件
plist_path = File.join(File.dirname(__FILE__), 'IDMPMiddleWare-AlfredKing-CMCC', 'IDMPCMCCDemo-Info.plist')
plistHash = Xcodeproj::Plist.read_from_path(plist_path)
if ARGV.size != 3 then
    puts "The params number is not match with 3"
else
    plistHash['CFBundleDisplayName'] = ARGV[0] #app显示名称
    plistHash['CFBundleIdentifier'] = ARGV[1] #bundle id
    plistHash['CFBundleVersion'] = ARGV[2] #bundle version
    
    Xcodeproj::Plist.write_to_path(plistHash, plist_path)
end

#保存project
project.save



