const cds = require('@sap/cds')
module.exports = cds.service.impl(async function () {
    const { Books, Authors } = this.entities
    this.on('create', Authors, async function (req) {
        const { Name, Age, Books: books } = req.data;
        const Author = await INSERT.into(Authors).entries({ Name, Age });
        if (books && books.length > 0) {
            for (const book of books) {
                await INSERT.into(Books).entries(
                    {
                        Title: book.Title, 
                        Genres:book.Genre,
                        AuthorID: Author.ID

                    });
            }
        }
        return Author
    })
})