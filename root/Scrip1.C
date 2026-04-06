{
    TH1F *h1 = new TH1F("h1", "Random expf1;X;Entries", 50, 0, 10);
    TH1F *h2 = new TH1F("h2", "Random gauss2;X;Entries", 50, 0, 10);
    TH1F *h3 = new TH1F("h3", "Random us3;X;Entries", 50, 0, 10);
    TFile *file = new TFile("scrip1.root", "RECREATE");
    TRandom3 *r = new TRandom3();
    
    Double_t x;

    for(Int_t i = 0; i < 200000; ++i){
        x = r->Exp(10);
        h1->Fill(x);
    }

    for(Int_t i = 0; i < 10000; i++){
        x = r->Gaus(5,0.5);
        h2->Fill(x);
    }

    for(Int_t i =0; i < 20000; i++){
        x = 10*r->Rndm();
        h3->Fill(x);
    }

    h3->SetFillColor(kBlue);
    h3 -> SetLineColor(kGreen);
    h1->Add(h2);
    h3->Multiply(h1);
    // h1->Draw();
    // h2->Draw();
    h3->Draw("HIST SAME");
    h3->Write();
    file->Close(); 
}