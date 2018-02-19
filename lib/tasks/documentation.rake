namespace :docs do
  desc "Creates the documentation in Swagger"
  task create: :environment do
    swaggered_classes = [
      ApplicationController,
      API::ArenasController,
    ]

    swagger_data = Swagger::Blocks.build_root_json(swaggered_classes)
    File.open("docs/swagger.json", "w") { |file| file.write(swagger_data.to_json) }
  end
end
