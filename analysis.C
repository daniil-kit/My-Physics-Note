void analysis() {
    // 1. Open the ROOT file
    // Check if the path is correct for your Windows setup
    TFile *f = TFile::Open("C:/root_v6.36.10/scrip1.root");
    
    // Safety check: was the file opened successfully?
    if (!f || f->IsZombie()) {
        printf("Error: Could not open file scrip1.root!\n");
        return;
    }

    // 2. Get the histogram by its internal name
    // Replace "name" with the actual name from f->ls()
   TH1F *h = (TH1F*)f->Get("h3");
    
    // Safety check: does the histogram exist?
    if (!h) {
        printf("Error: Histogram 'name' not found in the file!\n");
        f->Close();
        return;
    }

    // 3. Create a Canvas for rendering
    TCanvas *c = new TCanvas("c", "MEPhI Data Analysis", 800, 600);

    // Visual styling
    h->SetLineColor(kBlue+2); 
    h->SetLineWidth(2);       
    h->GetXaxis()->SetTitle("Energy (MeV)"); 
    h->GetYaxis()->SetTitle("Counts");       

    // 4. Draw the histogram
    h->Draw();

    // 5. Save as PNG for GitHub
    c->SaveAs("output_plot.png");

    // Close file to free memory
    f->Close();
    
    printf("Success! Plot saved as output_plot.png\n");
}