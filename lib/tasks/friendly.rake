namespace :friendly do
  desc <<-EOF
   Rebuild the Friendly indices. E.g.:
     ENV="name,industry" rake friendly:build_index[Product]
  EOF
  task :build_index, :class_name, :needs => [:environment] do |t, args|
    klass  = args[:class_name].constantize
    fields = ENV['FIELDS'].split(',').map { |f| f.to_sym }
    Friendly::Indexer.populate(klass, *fields)
  end
  
  task :create_tables, :needs => [:environment] do |t, args|
    Product.create_tables!
    y Friendly.create_tables!
  end
  
end
