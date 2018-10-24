namespace :tmp_files do
  desc "delete tmp files"
  task delete_uploads_tmp_files: :environment do |task|
    dir = File.join(File.dirname(__FILE__), "../../public/uploads/tmp/")
    system("rm -rf #{dir}*")
  end
end
