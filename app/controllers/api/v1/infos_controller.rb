module Api
    module V1
        class InfosController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            def index
                retVal = {}
                if Semantic.count > 0
                    init = RDF::Repository.new()
                    init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
                    uc = nil
                    init.each_graph{ |g| g.graph_name == "http://semantics.id/ns/semcon#UserConfigurations" ? uc = g : nil }
                    title = RDF::Query.execute(uc) { pattern [:subject, RDF::URI.new("http://purl.org/dc/elements/1.1/title"), :value] }.first.value.to_s
                    retVal["title"] = title
                end
                if ENV["IMAGE_NAME"].to_s != ""
                    retVal["image"] = ENV["IMAGE_NAME"].to_s
                end
                retVal["records"] = Store.count
                render json: retVal.to_json, 
                       status: 200

            end
        end
    end
end