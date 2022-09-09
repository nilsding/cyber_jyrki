require "../../../../spec_helper"

require "../../../../../src/cyber_jyrki/use_case/reddit/post/show"

describe CyberJyrki::UseCase::Reddit::Post::Show do
  before_each do
    WebMock.reset
  end

  it "returns info for an image post" do
    # reddit redirects our request to a more complete url
    WebMock.stub(:get, "https://www.reddit.com/x3gq5u.json")
      .to_return(status: 301, headers: {
        "location" => "https://www.reddit.com/r/gfur/comments/x3gq5u/sigmax/.json",
      })
    WebMock.stub(:get, "https://www.reddit.com/r/gfur/comments/x3gq5u/sigmax/.json")
      .to_return(status: 200, body: Fixtures::Reddit["thread_x3gq5u.json"])

    post = CyberJyrki::UseCase::Reddit::Post::Show.new(post_id: "x3gq5u").call
    post.subreddit.should eq "gfur"
    post.selftext.should eq ""
    post.title.should eq "(SigmaX)"
    post.author.should eq "justuraveragefurry"
    post.post_hint.should eq "image"
    post.is_self.should be_false
    post.permalink.should eq "/r/gfur/comments/x3gq5u/sigmax/"
    post.url.should eq "https://i.redd.it/5rvi43e5xal91.png"
    post.image?.should be_true
  end

  it "returns info for a self post" do
    # reddit redirects our request to a more complete url
    WebMock.stub(:get, "https://www.reddit.com/ve81a1.json")
      .to_return(status: 301, headers: {
        "location" => "https://www.reddit.com/r/Austria/comments/ve81a1/hallo_reddit_ich_bin_armin_wolf_journalist_und/.json",
      })
    WebMock.stub(:get, "https://www.reddit.com/r/Austria/comments/ve81a1/hallo_reddit_ich_bin_armin_wolf_journalist_und/.json")
      .to_return(status: 200, body: Fixtures::Reddit["thread_ve81a1.json"])

    post = CyberJyrki::UseCase::Reddit::Post::Show.new(post_id: "ve81a1").call
    post.subreddit.should eq "Austria"
    post.selftext.should match /^Ich arbeite seit meiner Matura für den ORF/
    post.title.should eq "Hallo Reddit! Ich bin Armin Wolf, Journalist und ZiB2-Moderator. Ask me anything!"
    post.author.should eq "WolfArmin"
    post.post_hint.should eq "self"
    post.is_self.should be_true
    post.permalink.should eq "/r/Austria/comments/ve81a1/hallo_reddit_ich_bin_armin_wolf_journalist_und/"
    post.url.should eq "https://www.reddit.com/r/Austria/comments/ve81a1/hallo_reddit_ich_bin_armin_wolf_journalist_und/"
    post.image?.should be_false
  end

  it "raises an error if the post could not be found" do
    WebMock.stub(:get, "https://www.reddit.com/notfound.json")
      .to_return(status: 404, body: %({"message": "Not Found", "error": 404}))

    expect_raises(Crest::NotFound) do
      CyberJyrki::UseCase::Reddit::Post::Show.new(post_id: "notfound").call
    end
  end
end
