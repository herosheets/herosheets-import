require 'pfrpg_import'
require 'pfrpg_classes'
require 'pfrpg_tables'

class HeroclassTask

  def initialize(uploaded_io)

    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @file = "./public/uploads/#{uploaded_io.original_filename}"
    @path = "./tmp/#{random_dir}/"
    if Dir.exists?("#{@path}")
      FileUtils.rm_rf("#{@path}")
    end
    # Dir.mkdir("#{@path}") unless Dir.exists?("#{@path}")
    Dir.mkdir("#{@path}")
  end

  def random_dir
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    return (0...50).map { o[rand(o.length)] }.join[0..12]
  end

  def validate
    exceptions = []
    f = PfrpgImport::HeroclassImporter.new(@file, @path)
    begin
      f.import_heroclass
    rescue Exception => e
      return { exceptions: [e] }
    end

    files = Dir.glob(@path + "/*")
    exceptions << "Files present: #{files.map { |x| x.split(@path)[1] }}"
    files.each do |file|
      begin
        load file
      rescue Exception => e
        exceptions << e unless mask(e)
      end
    end

    if exceptions.size == 1
      exceptions << "This file looks good!"
      facts = parsed_facts(f)
      levels = parsed_levels(f)
      spells = parsed_spells(f)
    end

    return { exceptions:exceptions, spells: spells, facts: facts, levels: levels }
  end

  def parsed_facts(importer)
    facts = importer.facts
    return {
        "Name" => facts.friendly_name,
        "Hit Die" => "d#{facts.hit_die}",
        "Starting Wealth" => "#{facts.start_wealth}",
        "Alignment" => "#{facts.alignment}",
        "Skills Per Level" => "#{facts.skills_per_level}",
        "Spells Bonus Attribute" => "#{facts.spells_bonus_attr}",
        "Description" => "#{facts.description}",
        "Class Skills" => "#{facts.class_skills}",
        "Starting Feats" => "#{facts.starting_feats}"
    }
  end

  def parsed_spells(importer)
    importer.spells
  end

  def parsed_levels(importer)
    importer.levels.map { |x| x.to_s(importer.facts.title) }
  end

  def mask(exception)
    exception.message['uninitialized constant ClassFeature']
  end
end
