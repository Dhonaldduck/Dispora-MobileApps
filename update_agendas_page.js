const fs = require('fs');
let content = fs.readFileSync('/home/dhonaldduck/Documents/Dispora-projects/dispora-web-admin/src/pages/AgendasPage.tsx', 'utf-8');

// Update Agenda interface
content = content.replace(
  /interface Agenda \{[\s\S]*?\}/,
  `interface Agenda {
  id: number;
  title: string;
  category?: string;
  description: string;
  location: string;
  startDate: string;
  endDate: string;
  organizer?: string;
  thumbnailUrl?: string;
}`
);

// Form state
content = content.replace(
  /const \[endDate, setEndDate\] = useState\(''\);/,
  `const [endDate, setEndDate] = useState('');
  const [category, setCategory] = useState('');
  const [organizer, setOrganizer] = useState('');
  const [posterFile, setPosterFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState('');`
);

// handle file change
const handleFileChangeCode = `
  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      setPosterFile(file);
      setPreviewUrl(URL.createObjectURL(file));
    }
  };
`;

content = content.replace(
  /const fetchAgendas = async \(\) => \{/,
  handleFileChangeCode + '\n  const fetchAgendas = async () => {'
);

// update submit
const newSubmitCode = `
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      let uploadedUrl = '';
      if (posterFile) {
        const formData = new FormData();
        formData.append('file', posterFile);
        const uploadRes = await api.post('/upload', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        // Handle different possible response structures
        uploadedUrl = uploadRes.data?.data?.url || uploadRes.data?.url || uploadRes.data || '';
      }

      await api.post('/agendas', { 
        title, 
        category,
        description,
        location,
        startDate: new Date(startDate).toISOString(),
        endDate: new Date(endDate).toISOString(),
        organizer,
        thumbnailUrl: uploadedUrl,
        isPublished: true
      });
      
      setIsModalOpen(false);
      resetForm();
      fetchAgendas();
    } catch (error) {
      console.error('Failed to create agenda', error);
      alert('Gagal menambahkan agenda');
    } finally {
      setIsSubmitting(false);
    }
  };
`;
content = content.replace(
  /const handleSubmit = async \(e: React.FormEvent\) => \{[\s\S]*?finally \{\s*setIsSubmitting\(false\);\s*\}\s*\};/,
  newSubmitCode
);

// update resetForm
const newResetCode = `
  const resetForm = () => {
    setTitle('');
    setCategory('');
    setDescription('');
    setLocation('');
    setStartDate('');
    setEndDate('');
    setOrganizer('');
    setPosterFile(null);
    setPreviewUrl('');
  };
`;
content = content.replace(
  /const resetForm = \(\) => \{[\s\S]*?setEndDate\(''\);\s*\};/,
  newResetCode
);

// Insert Image in table
content = content.replace(
  /<td className="px-6 py-4">\{item.id\}<\/td>/,
  `<td className="px-6 py-4">
    {item.thumbnailUrl ? (
      <img src={item.thumbnailUrl} alt={item.title} className="w-12 h-12 object-cover rounded-lg border border-slate-200" />
    ) : (
      <div className="w-12 h-12 bg-slate-100 rounded-lg border border-slate-200 flex items-center justify-center text-slate-400 text-xs">No Img</div>
    )}
  </td>`
);
content = content.replace(
  /<th className="px-6 py-4 font-semibold w-16">ID<\/th>/,
  `<th className="px-6 py-4 font-semibold w-20">Poster</th>`
);

// Form UI additions
const newFormUI = `
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  Poster Event
                </label>
                <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-slate-300 border-dashed rounded-lg">
                  <div className="space-y-1 text-center">
                    {previewUrl ? (
                      <div className="mb-4">
                        <img src={previewUrl} alt="Preview" className="mx-auto h-32 object-contain" />
                      </div>
                    ) : (
                      <svg className="mx-auto h-12 w-12 text-slate-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                        <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" />
                      </svg>
                    )}
                    <div className="flex text-sm text-slate-600 justify-center">
                      <label htmlFor="file-upload" className="relative cursor-pointer bg-white rounded-md font-medium text-primary-600 hover:text-primary-500 focus-within:outline-none">
                        <span>Unggah file</span>
                        <input id="file-upload" name="file-upload" type="file" className="sr-only" accept="image/*" onChange={handleFileChange} />
                      </label>
                      <p className="pl-1">atau tarik dan lepas</p>
                    </div>
                    <p className="text-xs text-slate-500">PNG, JPG, GIF hingga 5MB</p>
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="title">
                  Nama Agenda / Event
                </label>
                <input
                  id="title"
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                  placeholder="Masukkan nama kegiatan"
                  required
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="category">
                    Kategori / Cabang Olahraga
                  </label>
                  <input
                    id="category"
                    type="text"
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    placeholder="Misal: Sepak Bola, Lari"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="organizer">
                    Penyelenggara / Kontak
                  </label>
                  <input
                    id="organizer"
                    type="text"
                    value={organizer}
                    onChange={(e) => setOrganizer(e.target.value)}
                    className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                    placeholder="Nama penyelenggara"
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="location">
                  Lokasi / Fasilitas
                </label>
                <input
                  id="location"
                  type="text"
                  value={location}
                  onChange={(e) => setLocation(e.target.value)}
                  className="block w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors outline-none"
                  placeholder="Lokasi kegiatan"
                  required
                />
              </div>
`;

content = content.replace(
  /<div>\s*<label className="block text-sm font-medium text-slate-700 mb-1" htmlFor="title">[\s\S]*?placeholder="Lokasi kegiatan"\s*required\s*\/>\s*<\/div>/,
  newFormUI
);

fs.writeFileSync('/home/dhonaldduck/Documents/Dispora-projects/dispora-web-admin/src/pages/AgendasPage.tsx', content, 'utf-8');
console.log('AgendasPage.tsx updated successfully.');
