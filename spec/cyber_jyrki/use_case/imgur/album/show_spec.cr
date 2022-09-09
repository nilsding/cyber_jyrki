require "../../../../spec_helper"

require "../../../../../src/cyber_jyrki/use_case/imgur/album/show"

describe CyberJyrki::UseCase::Imgur::Album::Show do
  before_each do
    WebMock.reset
  end

  it "returns an album" do
    WebMock.stub(:get, "https://api.imgur.com/3/album/rgKesm5")
      .to_return(status: 200, body: Fixtures::Imgur["album_rgKesm5.json"])

    album = CyberJyrki::UseCase::Imgur::Album::Show.new(id: "rgKesm5").call
    album.id.should eq "rgKesm5"
    album.title.should eq "Billa"
    album.description.should be_nil
    album.datetime.should eq Time.utc(2022, 9, 2, 19, 8, 54)
    album.link.should eq "https://imgur.com/a/rgKesm5"
    album.is_ad.should be_false
    album.images.size.should eq 5
  end

  it "raises an error if the post could not be found" do
    WebMock.stub(:get, "https://api.imgur.com/3/album/notfound")
      .to_return(status: 404, body: "Post not found")

    expect_raises(Crest::NotFound) do
      CyberJyrki::UseCase::Imgur::Album::Show.new(id: "notfound").call
    end
  end
end
