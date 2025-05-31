require 'json'

def import_requirements(json_items, asvs_version, parent = nil)
  json_items.each do |item|
    # Handle ASVS 5.0+ format with flat "L"
    if item["L"]
      level = item["L"].to_i
      l1_required = level == 1
      l2_required = level == 2
      l3_required = level == 3
      l1_requirement = nil
      l2_requirement = nil
      l3_requirement = nil
    else
      # Handle ASVS 4.x format with L1/L2/L3 hash structure
      l1_required = item.dig("L1", "Required") || false
      l1_requirement = item.dig("L1", "Requirement")
      l2_required = item.dig("L2", "Required") || false
      l2_requirement = item.dig("L2", "Requirement")
      l3_required = item.dig("L3", "Required") || false
      l3_requirement = item.dig("L3", "Requirement")
    end

    req = Requirement.create!(
      asvs_version: asvs_version,
      parent: parent,
      shortcode: item["Shortcode"],
      ordinal: item["Ordinal"],
      name: item["Name"] || item["ShortName"],
      description: item["Description"],
      l1_required: l1_required,
      l1_requirement: l1_requirement,
      l2_required: l2_required,
      l2_requirement: l2_requirement,
      l3_required: l3_required,
      l3_requirement: l3_requirement,
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
  puts "📦 Processing file: #{File.basename(file_path)}"
  file = File.read(file_path)
  data = JSON.parse(file)

  # Skip if version already exists
  if AsvsVersion.exists?(version: data["Version"])
    puts "⚠️  Version #{data['Version']} already exists. Skipping #{File.basename(file_path)}."
    next
  end

  # Create ASVS version record
  asvs_version = AsvsVersion.create!(
    name: data["Name"],
    version: data["Version"],
    description: data["Description"],
    json_data: file
  )

  # Import requirements
  import_requirements(data["Requirements"], asvs_version)
  puts "✅ Imported version #{asvs_version.version} from #{File.basename(file_path)}"
end
