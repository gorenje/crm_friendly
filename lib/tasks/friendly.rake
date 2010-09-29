namespace :friendly do
  desc <<-EOF
    Rebuild the Friendly indices. E.g.:
      FIELDS="name,owner" rake friendly:build_index[Product]
    would populate the index for name+owner (i.e. not name, owner).
  EOF
  task :populate_index, :class_name, :needs => [:environment] do |t, args|
    klass  = args[:class_name].constantize
    fields = ENV['FIELDS'].split(',').map { |f| f.to_sym }
    Friendly::Indexer.populate(klass, *fields)
  end

  desc <<-EOF
    Create the tables for a particular Friendly based model, e.g:
      rake friendly:create_tables[Product]
    This also creates the index tables.
  EOF
  task :create_all_tables_for, :class_name, :needs => [:environment] do |t, args|
    args[:class_name].constantize.create_tables!
  end
end
