require "../../../../spec_helper"

require "../../../../../src/cyber_jyrki/use_case/fur_affinity/post/show"

describe CyberJyrki::UseCase::FurAffinity::Post::Show do
  before_each do
    WebMock.reset
  end

  it "extracts the data" do
    WebMock.stub(:get, "https://www.furaffinity.net/view/43876036/")
      .to_return(status: 200, body: Fixtures::FurAffinity["view_43876036.html"])

    post = CyberJyrki::UseCase::FurAffinity::Post::Show.new(post_id: "43876036").call
    post.valid?.should be_true
    post.title.should eq "Intruder [Commission]"
    post.artist.should eq "Jack_Mulroney"
    post.url.should eq "https://d.furaffinity.net/art/jackmulroney/1632621320/1632621303.jackmulroney_commic_page.jpg"
    post.rating.should eq CyberJyrki::Models::FurAffinity::Rating::General
  end

  it "returns an invalid post if the data could not be extracted" do
    WebMock.stub(:get, "https://www.furaffinity.net/view/43876036/")
      .to_return(status: 200, body: "<html>lol</html>")

    post = CyberJyrki::UseCase::FurAffinity::Post::Show.new(post_id: "43876036").call
    post.valid?.should be_false
    post.title.should eq ""
    post.artist.should eq ""
    post.url.should eq ""
    post.rating.should eq CyberJyrki::Models::FurAffinity::Rating::Unknown
  end

  it "raises an error if the post could not be found" do
    WebMock.stub(:get, "https://www.furaffinity.net/view/0/")
      .to_return(status: 404, body: Fixtures::FurAffinity["post_not_found.html"])

    expect_raises(Crest::NotFound) do
      CyberJyrki::UseCase::FurAffinity::Post::Show.new(post_id: "0").call
    end
  end

  it "raises an error if furaffinity is down" do
    WebMock.stub(:get, "https://www.furaffinity.net/view/43876036/")
      .to_return(status: 502, body: Fixtures::FurAffinity["502.html"])

    expect_raises(Crest::BadGateway) do
      CyberJyrki::UseCase::FurAffinity::Post::Show.new(post_id: "43876036").call
    end
  end
end
