describe Ruboty::WikiSearch::GitOperation do
  describe '#search' do
    subject { described_class.search(params) }

    let(:params) { { text: text, repo: repo  } }
    let(:text) { 'title' }
    let(:repo) { nil }

    context 'matches title' do
      let(:text) { 'title1' }

      it { is_expected.to eq({
        'kimromi/ruboty-wiki_search1' => {
          files: ['title1'],
          url: 'https://github.com/kimromi/ruboty-wiki_search1/wiki'
        }
      }) }
    end

    context 'match text' do
      let(:text) { 'text2' }

      it { is_expected.to eq({
        'kimromi/ruboty-wiki_search1' => {
          files: ['title2'],
          url: 'https://github.com/kimromi/ruboty-wiki_search1/wiki'
        }
      }) }
    end

    context 'match repository' do
      let(:text) { 'title' }
      let(:repo) { 'ruboty-wiki_search2' }

      it { is_expected.to eq({
        'kimromi/ruboty-wiki_search2' => {
          files: ['title3', 'title4'],
          url: 'https://github.com/kimromi/ruboty-wiki_search2/wiki'
        }
      }) }
    end

    context 'ignore Home.md' do
      let(:text) { 'Home' }

      it { is_expected.to be_empty }
    end

    context 'ignore _Sidebar.md' do
      let(:text) { '_Sidebar' }

      it { is_expected.to be_empty }
    end
  end
end
