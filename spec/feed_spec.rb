require_relative 'helper'
require_relative '../lib/ostatus/feed.rb'

describe OStatus::Feed do
  describe "#initialize" do
    it "should store a title" do
      OStatus::Feed.new(:title => "My Title").title.must_equal "My Title"
    end

    it "should store a list of authors" do
      author = mock('author')
      OStatus::Feed.new(:authors => [author]).authors.must_equal [author]
    end

    it "should store a list of entries" do
      entry = mock('entry')
      OStatus::Feed.new(:entries => [entry]).entries.must_equal [entry]
    end

    it "should store the id of the feed" do
      OStatus::Feed.new(:id => "id").id.must_equal "id"
    end

    it "should store the url for the feed" do
      OStatus::Feed.new(:url => "url").url.must_equal "url"
    end

    it "should store the published date" do
      time = mock('date')
      OStatus::Feed.new(:published => time).published.must_equal time
    end

    it "should store the updated date" do
      time = mock('date')
      OStatus::Feed.new(:updated => time).updated.must_equal time
    end
  end

  describe "#to_hash" do
    it "should return a Hash containing the title" do
      OStatus::Feed.new(:title => "My Title").to_hash[:title].must_equal "My Title"
    end

    it "should return a Hash containing a list of authors" do
      author = mock('author')
      OStatus::Feed.new(:authors => [author]).to_hash[:authors].must_equal [author]
    end

    it "should return a Hash containing a list of entries" do
      entry = mock('entry')
      OStatus::Feed.new(:entries => [entry]).to_hash[:entries].must_equal [entry]
    end

    it "should return a Hash containing the id of the feed" do
      OStatus::Feed.new(:id => "id").to_hash[:id].must_equal "id"
    end

    it "should return a Hash containing the url for the feed" do
      OStatus::Feed.new(:url => "url").to_hash[:url].must_equal "url"
    end

    it "should return a Hash containing the published date" do
      time = mock('date')
      OStatus::Feed.new(:published => time).to_hash[:published].must_equal time
    end

    it "should return a Hash containing the updated date" do
      time = mock('date')
      OStatus::Feed.new(:updated => time).to_hash[:updated].must_equal time
    end

    it "should default the authors to [] if not given" do
      OStatus::Feed.new.authors.must_equal []
    end

    it "should default the entries to [] if not given" do
      OStatus::Feed.new.entries.must_equal []
    end

    it "should default the title to 'Untitled' if not given" do
      OStatus::Feed.new.title.must_equal "Untitled"
    end

    it "should default the published field to DateTime.now if not given" do
      DateTime.stubs(:now).returns("NOW")
      OStatus::Feed.new.published.must_equal "NOW"
    end
  end

  describe "#to_atom" do
    it "should relegate Atom generation to OStatus::Atom::Feed" do
      atom_entry = mock('atom')
      atom_entry.expects(:to_xml).returns("ATOM")

      require_relative '../lib/ostatus/atom/feed.rb'

      OStatus::Atom::Feed.stubs(:new).returns(atom_entry)

      OStatus::Feed.new(:title => "foo").to_atom.must_equal "ATOM"
    end
  end
end
