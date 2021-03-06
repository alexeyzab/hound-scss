require "yaml"
require "scss_lint"

class ConfigOptions
  DEFAULT_CONFIG_FILE = "config/default.yml"

  def initialize(config)
    @valid = true
    begin
      @custom_options = YAML.safe_load(config || "", [Regexp])
    rescue Psych::Exception
      @valid = false
    end
  end

  def valid?
    valid
  end

  def to_hash
    merge(default_options, custom_options)
  end

  private

  attr_reader :custom_options, :valid

  def merge(base_options, options)
    merged_options = SCSSLint::Config.send(
      :smart_merge,
      base_options,
      options || {}
    )
    merged_options = SCSSLint::Config.send(
      :convert_single_options_to_arrays,
      merged_options
    )
    SCSSLint::Config.send(
      :merge_wildcard_linter_options,
      merged_options
    )
  end

  def default_options
    @default_config ||= YAML.load_file(DEFAULT_CONFIG_FILE)
  end
end
