require 'zip'

module Generator
  APP_ROOT = '../../'.freeze
  REFERENCE_PLACEHOLDER = '{{reference}}'
  TMP_DIR = "/tmp"

  class Base
    def self.generate(template_name)
      mainfile_name    = TEMPLATES[template_name]
      directory        = template_name

      new_reference    = Time.now.to_f.to_s.gsub('.', '')
      tmp_dir          = File.join(TMP_DIR, directory)

      mainfile_path    = File.join(tmp_dir, mainfile_name)

      FileUtils.cp_r(File.join('templates', directory), tmp_dir)

      mainfile_content = File.read(mainfile_path)

      mainfile_content.gsub!(REFERENCE_PLACEHOLDER, new_reference.to_s)
      File.open(mainfile_path, 'w') { |f| f.puts mainfile_content }


      zipfile_fullpath = File.join(TMP_DIR, "#{directory}-#{new_reference}.zip")
      input_files = Dir[File.join(tmp_dir, '*')]

      Zip::File.open(zipfile_fullpath, Zip::File::CREATE) do |zipfile|
        input_files.each do |filename|
          filepath = File.join(directory, File.basename(filename))
          zipfile.get_output_stream(filepath) { |f| f.write File.read(filename) }
        end
      end
      FileUtils.rm_r(tmp_dir)
      zipfile_fullpath
    end
  end
end
