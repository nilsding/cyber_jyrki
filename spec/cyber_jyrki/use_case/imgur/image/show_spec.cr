require "../../../../spec_helper"

require "../../../../../src/cyber_jyrki/use_case/imgur/image/show"

describe CyberJyrki::UseCase::Imgur::Image::Show do
  before_each do
    WebMock.reset
  end

  it "returns an image" do
    WebMock.stub(:get, "https://api.imgur.com/3/image/ZFsYyPj")
      .to_return(status: 200, body: Fixtures::Imgur["image_ZFsYyPj.json"])

    image = CyberJyrki::UseCase::Imgur::Image::Show.new(id: "ZFsYyPj").call
    image.id.should eq "ZFsYyPj"
    image.title.should be_nil
    image.description.should be_nil
    image.datetime.should eq Time.utc(2022, 9, 2, 19, 8, 58)
    image.type.should eq "image/png"
    image.animated.should be_false
    image.width.should eq 2304
    image.height.should eq 1536
    image.size.should eq 3437567
    image.is_ad.should be_false
    image.link.should eq "https://i.imgur.com/ZFsYyPj.png"
  end

  it "raises an error if the post could not be found" do
    WebMock.stub(:get, "https://api.imgur.com/3/image/notfound")
      .to_return(status: 404, body: "Post not found")

    expect_raises(Crest::NotFound) do
      CyberJyrki::UseCase::Imgur::Image::Show.new(id: "notfound").call
    end
  end
end
