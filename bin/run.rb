require 'pry'
require 'yaml'
require 'thor'
require 'neatjson'

# Terraform class is a CLI wrapper to generate Terraform module tf.json
# which would then allow user to be able to apply terraform per module.
class AmpCli < Thor
  desc 'version', 'print the version'
  def version
    puts '0.0.1'
  end

  desc 'terraform ENV SITE', 'Run Terraform, pass environment and site'
  def terraform(environment, site)
    Config.new(environment: environment, site: site).parse
  end

  desc 'ansible', 'Run Ansible'
  def ansible
    puts 'Ansible placeholder'
  end
end

# Config class is to load, parse and generate config Terraform module
# config tf.json.
class Config
  def initialize(environment: '', site: '')
    site    = site 
    dir     = 'config/' + environment
    @config = dir + '/' + site + '.yaml'
  end

  def load_file
    YAML.load_file(@config)
  rescue Errno::ENOENT => e
    raise "Error: #{e}"
  end

  def parse
    data = load_file
    data.delete('defaults')
    dump(json_data: generate_json(data: json_data(data: data)))
  end

  def dump(json_data: {})
    File.write('root.tf.json', json_data) 
  end

  def generate_json(data: {})
    opts = { wrap: 0, sort: false, aligned: true,
             padding: 1, around_colon: 1, around_comma: 1 }

    JSON.neat_generate(data, opts)
  end

  def json_data(data: {})
    { 'module' => data }
  end
end

AmpCli.start

