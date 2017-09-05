require 'sparkle_formation'
RSpec.describe StackMaster::TemplateCompilers::SparkleFormation do

  describe '.compile' do
    def compile
      described_class.compile(template_file_path, nil, compiler_options)
    end

    let(:template_file_path) {'/base_dir/templates/template.rb'}
    let(:compiler_options) {{}}
    let(:sparkle_template) {instance_double(::SparkleFormation)}
    before do
      allow(::SparkleFormation).to receive(:compile).with(template_file_path, :sparkle).and_return(sparkle_template)
      allow(sparkle_template).to receive(:compile_time_parameter_setter)
      allow(sparkle_template).to receive(:parameters).and_return([])
      allow(JSON).to receive(:pretty_generate).with(sparkle_template).and_return("{\n}")
    end

    it 'compiles with sparkleformation' do
      expect(compile).to eq("{\n}")
    end

    it 'sets the appropriate sparkle_path' do
      compile
      expect(::SparkleFormation.sparkle_path).to eq File.dirname(template_file_path)
    end

    context 'with a custom sparkle_path' do
      let(:compiler_options) {{"sparkle_path" => '../foo'}}

      it 'does not use the default path' do
        compile
        expect(::SparkleFormation.sparkle_path).to_not eq File.dirname(template_file_path)
      end

      it 'expands the given path' do
        compile
        expect(::SparkleFormation.sparkle_path).to match %r{^/.+/foo}
      end
    end
  end

end
