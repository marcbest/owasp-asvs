require 'json'

def import_requirements(json_items, asvs_version, parent = nil)
  json_items.each do |item|
    req = Requirement.create!(
      asvs_version: asvs_version,
      parent: parent,
      shortcode: item["Shortcode"],
      ordinal: item["Ordinal"],
      name: item["Name"] || item["ShortName"],
      description: item["Description"],
      l1_required: item.dig("L1", "Required"),
      l1_requirement: item.dig("L1", "Requirement"),
      l2_required: item.dig("L2", "Required"),
      l2_requirement: item.dig("L2", "Requirement"),
      l3_required: item.dig("L3", "Required"),
      l3_requirement: item.dig("L3", "Requirement"),
      cwe: (item["CWE"] || []).join(", "),
      nist: (item["NIST"] || []).join(", ")
    )

    # Recursively import any nested items
    if item["Items"].present? && item["Items"].is_a?(Array)
      import_requirements(item["Items"], asvs_version, req)
    end
  end
end

Dir.glob(Rails.root.join("db", "data", "versions", "*.json")).each do |file_path|
  puts "Processing file: #{File.basename(file_path)}"
  file = File.read(file_path)
  data = JSON.parse(file)

  # Check if we already have this version in the database
  existing_version = AsvsVersion.find_by(version: data["Version"])

  if existing_version
    puts "Version #{data['Version']} already exists. Skipping #{File.basename(file_path)}."
    next
  end

  # Create a new ASVS version
  asvs_version = AsvsVersion.create!(
    name: data["Name"],
    version: data["Version"],
    description: data["Description"],
    json_data: file
  )

  # Import the nested requirements
  import_requirements(data["Requirements"], asvs_version)
  puts "Imported version #{asvs_version.version} from #{File.basename(file_path)}"
end
