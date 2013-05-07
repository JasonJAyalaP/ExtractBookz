#!/usr/bin/env ruby

module ExtractBookz
  require 'tmpdir'

  def self.process source_dir, target_dir
    sub_dirs = Dir.entries(source_dir).select {|d| File.directory? File.join(source_dir, d) and !(d =='.' || d == '..') }
    if sub_dirs.size == 0
      extract_book_dir source_dir, target_dir
    else
      sub_dirs.each { |sub_dir| extract_book_dir File.join(source_dir, sub_dir), target_dir }
    end
  end

  def self.extract_book_dir book_dir, target_dir
    book_name = book_name_from book_dir

    unzip_path = CheckTool.tool_path_for 'unzip'
    unrar_path = CheckTool.tool_path_for 'unrar'

    # TODO: $?.success?
    Dir.mktmpdir do |tmp_book_dir|

      `#{unzip_path} -qo "#{File.join book_dir, '*.zip'}" -d "#{tmp_book_dir}"`
      `#{unrar_path} -o+ -inul e "#{File.join book_dir, '*.rar'}" "#{tmp_book_dir}"`
      `#{unrar_path} -o+ -inul e "#{tmp_book_dir}/*.rar" "#{tmp_book_dir}"`

      # Move book into place
      Dir.glob(File.join tmp_book_dir, "*.{pdf,epub,mobi}").each do |book_file|
        FileUtils.mv book_file, File.join(target_dir, book_name + (File.extname book_file))
        puts "Extracted: #{book_name}"
      end

    end
  end

  def self.book_name_from book_dir
    clean_name = File.basename book_dir
    clean_name.sub!(/.\d{4}.*$/,'') # from .YEAR to end
    clean_name.sub!(/^.*-/,'') # from beginning to -
    clean_name.gsub!('.',' ') # spaces for .
    clean_name.gsub!('_',' ') # spaces for _
    clean_name.strip! # trailing/leading whitespaces
    if book_dir =~ /(ELOHiM|repackb00k|BBL|DDU)$/
      clean_name.sub!(/^\S*\s*/, '') # remove publisher (first word)
      clean_name.sub!(/\s.{3}$/, '') # remove three letter month
    elsif book_dir =~ /Ebookers$/
      clean_name.sub!(/\s.{3}$/, '')
    end
    clean_name
  end

end

module CheckTool

  def self.tool_path_for tool_name
    # Adds CWD check on top of which.

    # First try which
    tool_path = which tool_name
    return tool_path if tool_path

    # Then look at current directory
    os = RUBY_PLATFORM.downcase # File.executable isn't OS aware
    if (os.include?("win32") || os.include?("mingw")) && File.executable?("#{tool_name}.exe")
        return "#{tool_name}.exe"
    elsif os.include?("darwin") && File.executable?(tool_name)
      return "./#{tool_name}"
    else
      raise "#{tool_name} not found!"
    end

  end

  def self.which cmd
    # Cross-platform way of finding an executable in the $PATH.
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each do |ext|
        exe = "#{path}/#{cmd}#{ext}"
        return exe if File.executable? exe
      end
    end
    return nil
  end
end

if ARGV[0] then
  source_dir = ARGV[0]
  target_dir = ARGV[1] || source_dir
  ExtractBookz.process source_dir, target_dir
end
